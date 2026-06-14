#include "voice.h"
#include <cmath>

// =========================================================
// ===================   GODOT BINDINGS   ==================
// =========================================================

void Voice::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_frequency", "frequency"),  &Voice::set_frequency);
    ClassDB::bind_method(D_METHOD("get_frequency"),  &Voice::get_frequency);
    ClassDB::bind_method(D_METHOD("set_active", "active"),  &Voice::set_active);
    ClassDB::bind_method(D_METHOD("get_active"),  &Voice::get_active);


    ClassDB::bind_method(D_METHOD("process", "delta"), &Voice::process);
    ClassDB::bind_method(D_METHOD("set_graph",
        "types",
        "input_offsets",     "input_counts",
        "output_offsets",    "output_counts",
        "state_offsets",     "state_counts",
        "parameter_offsets", "parameter_counts",
        "parameter_values"
    ), &Voice::set_graph);

    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "frequency"), "set_frequency", "get_frequency");
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "active"), "set_active", "get_active");
}

// =========================================================
// ==================   SETTERS/GETTERS   ==================
// =========================================================

void Voice::set_active(const bool active_p) { active = active_p; }
bool Voice::get_active() { return active; }

void Voice::set_frequency(const double frequency_p) { frequency = frequency_p; }
double Voice::get_frequency() { return frequency; }

std::array<Voice::ModuleFunction, Voice::MODULE_TYPE_COUNT> Voice::dispatch_table = {
    Voice::process_input_module,
    Voice::process_oscillator_module,
    Voice::process_envelope_module,
    Voice::process_arithmetic_module,
    Voice::process_output_module,
};

void Voice::set_graph(
    const PackedByteArray  &types,
    const PackedInt32Array &input_offsets,
    const PackedInt32Array &input_counts,
    const PackedInt32Array &output_offsets,
    const PackedInt32Array &output_counts,
    const PackedInt32Array &state_offsets,
    const PackedInt32Array &state_counts,
    const PackedInt32Array &parameter_offsets,
    const PackedInt32Array &parameter_counts,
    const PackedFloat64Array &parameter_values
) {
    int module_count = types.size();
    modules.resize(module_count);
    for (int i = 0; i < module_count; i++) {
        Module &m          = modules.write[i];
        m.type             = types[i];
        m.input_offset     = input_offsets[i];
        m.input_count      = input_counts[i];
        m.output_offset    = output_offsets[i];
        m.output_count     = output_counts[i];
        m.state_offset     = state_offsets[i];
        m.state_count      = state_counts[i];
        m.parameter_offset = parameter_offsets[i];
        m.parameter_count  = parameter_counts[i];
    }

    int max_connection = 0;
    for (int i = 0; i < module_count; i++) {
        int in_end  = modules[i].input_offset  + modules[i].input_count;
        int out_end = modules[i].output_offset + modules[i].output_count;
        if (in_end  > max_connection) max_connection = in_end;
        if (out_end > max_connection) max_connection = out_end;
    }
    connections.resize(max_connection);
    connections.fill(0.0);

    int max_state = 0;
    for (int i = 0; i < module_count; i++) {
        int end = modules[i].state_offset + modules[i].state_count;
        if (end > max_state) max_state = end;
    }
    states.resize(max_state);
    states.fill(0.0);

    int parameter_count = parameter_values.size();
    parameters.resize(parameter_count);
    for (int i = 0; i < parameter_count; i++) {
        parameters.write[i] = parameter_values[i];
    }
}

// =========================================================
// ======================   PROCESS   ======================
// =========================================================

double Voice::process(double delta) {
    connections.write[0] = frequency;
    connections.write[1] = active ? 1.0 : 0.0;

    for (int i = 0; i < modules.size(); i++) {
        dispatch_table[modules[i].type](modules[i], connections, states, parameters, delta);
    }
    return connections[2]; // sample
}

// =========================================================
// INPUT module
//
// outputs[0]    = frequency : float
// outputs[1]    = active : bool
//
// =========================================================

void Voice::process_input_module(
    const Module &m,
    Vector<double> &connections,
    Vector<double> &states,
    Vector<double> &parameters,
    double delta
) {
    connections.write[m.output_offset + 0] = connections[m.input_offset + 0]; // frequency
    connections.write[m.output_offset + 1] = connections[m.input_offset + 1]; // active
}

// =========================================================
// OSCILLATOR module
//
// inputs[0]     = frequency : float
// outputs[0]    = sample : float
// states[0]     = phase accumulation : float
// parameters[0] = waveform : enum { SINE, SQUARE, SAW, TRIANGLE }
// 
// =========================================================

static constexpr double TWO_PI = 2.0 * M_PI;

void Voice::process_oscillator_module(
    const Module &m,
    Vector<double> &connections,
    Vector<double> &states,
    Vector<double> &parameters,
    double delta
) {
    double frequency = connections[m.input_offset];
    int    waveform  = static_cast<int>(std::round(parameters[m.parameter_offset]));
    double &phase    = states.write[m.state_offset];

    phase += TWO_PI * frequency * delta;
    if (phase >= TWO_PI) phase -= TWO_PI;

    double sample = 0.0;
    switch (waveform) {
        case 0: // Sine
            sample = std::sin(phase);
            break;
        case 1: // Square
            sample = (phase < M_PI) ? 1.0 : -1.0;
            break;
        case 2: // Saw
            sample = (phase / M_PI) - 1.0;
            break;
        case 3: // Triangle
            sample = (phase < M_PI)
                ? (phase / (M_PI * 0.5)) - 1.0
                : 3.0 - (phase / (M_PI * 0.5));
            break;
        default:
            sample = 0.0;
    }

    connections.write[m.output_offset] = sample;
}

// =====================================================================
// ENVELOPE module
// 
// inputs[0]     = gate : bool
// outputs[0]    = level : float
// states[0]     = level : float
// states[1]     = stage : enum { IDLE, ATTACK, DECAY, SUSTAIN, RELEASE }
// parameters[0] = attack : float
// parameters[1] = decay : float
// parameters[2] = sustain : float
// parameters[3] = release : float
//
// =====================================================================

void Voice::process_envelope_module(
    const Module &m,
    Vector<double> &connections,
    Vector<double> &states,
    Vector<double> &parameters,
    double delta
) {
    double gate    = connections[m.input_offset];
    double attack  = parameters[m.parameter_offset + 0];
    double decay   = parameters[m.parameter_offset + 1];
    double sustain = parameters[m.parameter_offset + 2];
    double release = parameters[m.parameter_offset + 3];
    double &level  = states.write[m.state_offset + 0];
    double &stage  = states.write[m.state_offset + 1];

    bool gated = gate >= 0.5;

    if (gated  && (stage == 0.0 || stage == 4.0)) stage = 1.0; // idle/release -> attack
    if (!gated && stage != 0.0 && stage != 4.0)   stage = 4.0; // any -> release

    switch (static_cast<int>(stage)) {
        case 1: // Attack
            level += delta / std::max(attack, 1e-6);
            if (level >= 1.0) { level = 1.0; stage = 2.0; }
            break;
        case 2: // Decay
            level -= delta / std::max(decay, 1e-6) * (1.0 - sustain);
            if (level <= sustain) { level = sustain; stage = 3.0; }
            break;
        case 3: // Sustain
            level = sustain;
            break;
        case 4: // Release
            level -= delta / std::max(release, 1e-6) * level;
            if (level <= 0.001) { level = 0.0; stage = 0.0; }
            break;
        default: // Idle
            level = 0.0;
    }

    connections.write[m.output_offset] = level;
}

// =====================================================================
// ARITHMETIC module
//
// inputs[0]     = operand_a : float
// inputs[1]     = operand_b : float
// outputs[0]    = result : float
// parameters[0] = operation : enum { ADD, SUBTRACT, MULTIPLY, DIVIDE }
//
// =====================================================================

void Voice::process_arithmetic_module(
    const Module &m,
    Vector<double> &connections,
    Vector<double> &states,
    Vector<double> &parameters,
    double delta
) {
    double a  = connections[m.input_offset + 0];
    double b  = connections[m.input_offset + 1];
    int    op = (m.parameter_count > 0) ? static_cast<int>(std::round(parameters[m.parameter_offset])) : 0;

    double result = 0.0;
    switch (op) {
        case 0: result = a + b;                                  break;
        case 1: result = a - b;                                  break;
        case 2: result = a * b;                                  break;
        case 3: result = (std::abs(b) > 1e-9) ? a / b : 0.0;   break;
        default: result = 0.0;
    }

    connections.write[m.output_offset] = result;
}

// =====================================================================
// OUTPUT module
//
// inputs[0]     = sample : float
//
// =====================================================================

void Voice::process_output_module(
    const Module &m,
    Vector<double> &connections,
    Vector<double> &states,
    Vector<double> &parameters,
    double delta
) {
    connections.write[2] = connections[m.input_offset];
}