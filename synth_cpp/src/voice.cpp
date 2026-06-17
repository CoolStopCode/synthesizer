#include "voice.h"
#include <cmath>
#include <godot_cpp/variant/utility_functions.hpp>

// =========================================================
// ===================   GODOT BINDINGS   ==================
// =========================================================

void Voice::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_frequency", "frequency"),  &Voice::set_frequency);
    ClassDB::bind_method(D_METHOD("get_frequency"),  &Voice::get_frequency);
    ClassDB::bind_method(D_METHOD("set_active", "active"),  &Voice::set_active);
    ClassDB::bind_method(D_METHOD("get_active"),  &Voice::get_active);


    ClassDB::bind_method(D_METHOD("process", "delta"), &Voice::process);
    ClassDB::bind_method(D_METHOD(
        "set_graph",
        "types",
        "input_offsets",
        "output_offsets",
        "state_offsets",
        "parameter_offsets",
        "input_routes",
        "initial_memory_data"
    ), &Voice::set_graph);

    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "frequency"), "set_frequency", "get_frequency");
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "active"), "set_active", "get_active");
}

// =========================================================
// ==================   SETTERS/GETTERS   ==================
// =========================================================

void Voice::set_frequency(const double frequency_p) { frequency = frequency_p; }
double Voice::get_frequency() { return frequency; }

void Voice::set_active(const bool active_p) { active = active_p; }
bool Voice::get_active() { return active; }


std::array<Voice::ModuleFunction, Voice::MODULE_TYPE_COUNT> Voice::dispatch_table = {
    Voice::process_input_module,
    Voice::process_output_module,

    Voice::process_oscillator_module,
    Voice::process_noise_module,

    Voice::process_envelope_module,
    Voice::process_equalizer_module,
    Voice::process_bitcrusher_module,

    Voice::process_arithmetic_module,
};

void Voice::set_graph(
    const PackedByteArray &types_p, // Array of ModuleType

    const PackedInt32Array &input_offsets_p,
    const PackedInt32Array &output_offsets_p,
    const PackedInt32Array &state_offsets_p,
    const PackedInt32Array &parameter_offsets_p,
    
    const PackedInt32Array &input_routes_p, // Array of memory_data indices
    const PackedFloat64Array &initial_memory_data_p // memory_data
) {
    int module_count = types_p.size();
    modules.resize(module_count);
    for (int i = 0; i < module_count; i++) {
        Module &m          = modules[i];
        
        m.type             = types_p[i];
        m.input_offset     = input_offsets_p[i];
        m.output_offset    = output_offsets_p[i];
        m.state_offset     = state_offsets_p[i];
        m.parameter_offset = parameter_offsets_p[i];
    }

    int input_routes_count = input_routes_p.size();
    input_routes.resize(input_routes_count);
    for (int i = 0; i < input_routes_count; i++) {
        input_routes[i] = (uint32_t)input_routes_p[i];
    }

    int initial_memory_data_count = initial_memory_data_p.size();
    memory_data.resize(initial_memory_data_count);
    for (int i = 0; i < initial_memory_data_count; i++) {
        memory_data[i] = initial_memory_data_p[i];
    }
}

// =========================================================
// ======================   PROCESS   ======================
// =========================================================

double Voice::process(double delta) {
    double *memory_data_pointer = memory_data.data();
    const u_int32_t *input_routes_pointer = input_routes.data();

    write_memory(1, frequency, memory_data.data()); 
    write_memory(2, bool_to_double(active), memory_data.data()); 
    
    for (int i = 0; i < modules.size(); i++) {
        dispatch_table[modules[i].type](modules[i], memory_data_pointer, input_routes_pointer, delta);
    }

    return read_memory(3, memory_data_pointer);
}

// =========================================================
// ======================   HELPERS   ======================
// =========================================================

inline double Voice::read_input(
    uint32_t index,
    double* memory_data,
    const uint32_t* input_routes
) {
    return memory_data[input_routes[index]];
}

inline double Voice::read_memory(
    uint32_t index,
    double* memory_data
) {
    return memory_data[index];
}

inline void Voice::write_memory(
    uint32_t index,
    double value,
    double* memory_data
) {
    memory_data[index] = value;
}

inline int Voice::double_to_int(double double_p) {
    return static_cast<int>(std::round(double_p));
}

inline bool Voice::double_to_bool(double double_p) {
    return double_p != 0.0;
}

inline double Voice::bool_to_double(bool double_p) {
    return double_p ? 1.0 : 0.0;
}

inline double Voice::int_to_double(int double_p) {
    return static_cast<double>(double_p);
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
    double* memory_data,
    const uint32_t* input_routes,
    double delta
) {
    double frequency_in = read_memory(1, memory_data);
    double active_in    = read_memory(2, memory_data);
    write_memory(m.output_offset + 0, frequency_in, memory_data); // frequency
    write_memory(m.output_offset + 1, active_in   , memory_data); // active
}

// =====================================================================
// OUTPUT module
//
// inputs[0]     = sample : float
//
// =====================================================================

void Voice::process_output_module(
    const Module &m,
    double* memory_data,
    const uint32_t* input_routes,
    double delta
) {
    double input_value = read_input(m.input_offset, memory_data, input_routes);

    write_memory(3, input_value, memory_data);
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

void Voice::process_oscillator_module(
    const Module &m,
    double* memory_data,
    const uint32_t* input_routes,
    double delta
) {
    double frequency = read_input(m.input_offset + 0, memory_data, input_routes);
    int    waveform  = double_to_int(read_memory(m.parameter_offset + 0, memory_data));
    double phase = read_memory(m.state_offset + 0, memory_data);

    double next_phase = std::fmod(phase + Math_TAU * frequency * delta, Math_TAU);
    write_memory(m.state_offset + 0, next_phase, memory_data);

    double sample = 0.0;
    switch (waveform) {
        case 0: // Sine
            sample = std::sin(next_phase);
            break;
        case 1: // Square
            sample = (next_phase < M_PI) ? 1.0 : -1.0;
            break;
        case 2: // Saw
            sample = (next_phase / M_PI) - 1.0;
            break;
        case 3: // Triangle
            sample = (next_phase < M_PI)
                ? (next_phase / (M_PI * 0.5)) - 1.0
                : 3.0 - (next_phase / (M_PI * 0.5));
            break;
        default:
            sample = 0.0;
    }

    write_memory(m.output_offset, sample, memory_data);
}

// =========================================================
// NOISE module
//
// outputs[0]    = sample : float
// parameters[0] = spectrum : enum { WHITE, PINK, BROWN, VIOLET, }
// 
// =========================================================

void Voice::process_noise_module(
    const Module &m,
    double* memory_data,
    const uint32_t* input_routes,
    double delta
) {

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
    double* memory_data,
    const uint32_t* input_routes,
    double delta
) {
    double gate    = read_input(m.input_offset, memory_data, input_routes);
    double attack  = read_memory(m.parameter_offset + 0, memory_data);
    double decay   = read_memory(m.parameter_offset + 1, memory_data);
    double sustain = read_memory(m.parameter_offset + 2, memory_data);
    double release = read_memory(m.parameter_offset + 3, memory_data);

    double level = read_memory(m.state_offset + 0, memory_data);
    int stage = double_to_int(read_memory(m.state_offset + 1, memory_data));

    bool gated = double_to_bool(gate);

    if (gated  && (stage == 0 || stage == 4)) stage = 1; // Idle/Release -> Attack
    if (!gated && stage != 0 && stage != 4)   stage = 4; // Any state -> Release

    // 4. State Machine Execution
    switch (stage) {
        case 0: // Idle
            level = 0.0;
            break;
        case 1: // Attack
            level += delta / std::max(attack, 1e-6);
            if (level >= 1.0) { 
                level = 1.0; 
                stage = 2; 
            }
            break;
        case 2: // Decay
            level -= (delta / std::max(decay, 1e-6)) * (1.0 - sustain);
            if (level <= sustain) { 
                level = sustain; 
                stage = 3; 
            }
            break;
        case 3: // Sustain
            level = sustain;
            break;
        case 4: // Release
            level -= (delta / std::max(release, 1e-6)) * level;
            if (level <= 0.001) { 
                level = 0.0; 
                stage = 0; 
            }
            break;
        default:
            level = 0.0;
            break;
    }

    write_memory(m.state_offset + 0, level, memory_data);
    write_memory(m.state_offset + 1, int_to_double(stage), memory_data);
    write_memory(m.output_offset, level, memory_data);
}

// =====================================================================
// EQUALIZER module
// 
// inputs[0]     = audio_in : float
// outputs[0]    = audio_out : float
// states[0]     = x1 : float
// states[1]     = x2 : float
// states[2]     = y1 : float
// states[3]     = y2 : float
// parameters[0] = filter_type : enum { PEAK, LOW_SHELF, HIGH_SHELF, HPF, LPF }
// parameters[1] = frequency : float
// parameters[2] = gain : float
// parameters[3] = q_factor : float
//
// =====================================================================

void Voice::process_equalizer_module(
    const Module &m,
    double* memory_data,
    const uint32_t* input_routes,
    double delta
) {

}

// =====================================================================
// BITCRUSHER module
// 
// inputs[0]     = audio_in : float
// outputs[0]    = audio_out : float
// states[0]     = sample_hold_value : float
// states[1]     = phase_accumulation : float
// parameters[0] = bit_depth : float
// parameters[1] = downsample_factor : float
// parameters[2] = mix : float
//
// =====================================================================

void Voice::process_bitcrusher_module(
    const Module &m,
    double* memory_data,
    const uint32_t* input_routes,
    double delta
) {

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
    double* memory_data,
    const uint32_t* input_routes,
    double delta
) {
    double a = read_input(m.input_offset + 0, memory_data, input_routes);
    double b = read_input(m.input_offset + 1, memory_data, input_routes);
    
    int op = double_to_int(read_memory(m.parameter_offset, memory_data));

    double result = 0.0;
    switch (op) {
        case 0: result = a + b;                                break; // Addition
        case 1: result = a - b;                                break; // Subtraction
        case 2: result = a * b;                                break; // Multiplication
        case 3: result = (std::abs(b) > 1e-9) ? a / b : 0.0;   break; // Division
        default: result = 0.0;
    }

    write_memory(m.output_offset, result, memory_data);
}