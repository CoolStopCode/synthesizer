#include "modular_audio_voice.h"
#include <cmath>
#include <godot_cpp/variant/utility_functions.hpp>

// =========================================================
// ===================   GODOT BINDINGS   ==================
// =========================================================

void ModularAudioVoice::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_frequency", "frequency"),  &ModularAudioVoice::set_frequency);
    ClassDB::bind_method(D_METHOD("get_frequency"),  &ModularAudioVoice::get_frequency);
    ClassDB::bind_method(D_METHOD("set_pressed", "pressed"),  &ModularAudioVoice::set_pressed);
    ClassDB::bind_method(D_METHOD("get_pressed"),  &ModularAudioVoice::get_pressed);
    ClassDB::bind_method(D_METHOD("set_amplitude", "amplitude"),  &ModularAudioVoice::set_amplitude);
    ClassDB::bind_method(D_METHOD("get_amplitude"),  &ModularAudioVoice::get_amplitude);

    ClassDB::bind_method(D_METHOD("bend_frequency_to", "target", "duration"), &ModularAudioVoice::bend_frequency_to);
    ClassDB::bind_method(D_METHOD("bend_amplitude_to", "target", "duration"), &ModularAudioVoice::bend_amplitude_to);

    ClassDB::bind_method(D_METHOD("process", "delta"), &ModularAudioVoice::process);
    ClassDB::bind_method(D_METHOD(
        "set_layout",
        "types",
        "module_offsets",
        "output_offsets",
        "output_routes",
        "memory_data"
    ), &ModularAudioVoice::set_layout);

    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "frequency"), "set_frequency", "get_frequency");
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "pressed"), "set_pressed", "get_pressed");
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "amplitude"), "set_amplitude", "get_amplitude");
}

// =========================================================
// ==================   SETTERS/GETTERS   ==================
// =========================================================

void ModularAudioVoice::set_frequency(const double frequency_p) { frequency = frequency_p; frequency_target = frequency_p; }
double ModularAudioVoice::get_frequency() { return frequency; }
void ModularAudioVoice::bend_frequency_to(const double target, const double duration) {
	frequency_start = frequency;
	frequency_target = target;
	frequency_bend_duration = duration;
	frequency_bend_elapsed = 0.0;
}

void ModularAudioVoice::set_amplitude(const double amplitude_p) { amplitude = amplitude_p; amplitude_target = amplitude_p; }
double ModularAudioVoice::get_amplitude() { return amplitude; }
void ModularAudioVoice::bend_amplitude_to(const double target, const double duration) {
	amplitude_start = amplitude;
	amplitude_target = target;
	amplitude_bend_duration = duration;
	amplitude_bend_elapsed = 0.0;
}

void ModularAudioVoice::set_pressed(const bool pressed_p) { pressed = pressed_p; }
bool ModularAudioVoice::get_pressed() { return pressed; }

std::array<ModularAudioVoice::ModuleFunction, ModularAudioVoice::MODULE_TYPE_COUNT> ModularAudioVoice::dispatch_table = {
    ModularAudioVoice::process_input_module,
    ModularAudioVoice::process_output_module,

    ModularAudioVoice::process_oscillator_module,
    ModularAudioVoice::process_noise_module,

    ModularAudioVoice::process_envelope_module,
    ModularAudioVoice::process_filter_module,
    ModularAudioVoice::process_bitcrusher_module,

    ModularAudioVoice::process_arithmetic_module,
};

void ModularAudioVoice::set_layout(
    const PackedByteArray &types_p, // Array of ModuleType

    const PackedInt32Array &module_offsets_p,
    const PackedInt32Array &output_offsets_p,
    
    const PackedInt32Array &output_routes_p, // Array of memory_data indices
    const PackedFloat64Array &memory_data_p // memory_data
) {
    int module_count = types_p.size();
    modules.resize(module_count);
    for (int i = 0; i < module_count; i++) {
        Module &module     = modules[i];
        
        module.type             = types_p[i];
        module.module_offset    = module_offsets_p[i];
        module.output_offset    = output_offsets_p[i];
    }

    int output_routes_count = output_routes_p.size();
    output_routes.resize(output_routes_count);
    for (int i = 0; i < output_routes_count; i++) {
        output_routes[i] = (uint32_t)output_routes_p[i];
    }

    int memory_data_count = memory_data_p.size();
    memory_data.resize(memory_data_count);
    for (int i = 0; i < memory_data_count; i++) {
        memory_data[i] = memory_data_p[i];
    }
}

// =========================================================
// ======================   PROCESS   ======================
// =========================================================

double ModularAudioVoice::process(double delta) {
    if (frequency_bend_elapsed < frequency_bend_duration) {
        frequency_bend_elapsed += delta;
        double t = CLAMP(frequency_bend_elapsed / frequency_bend_duration, 0.0, 1.0);
        frequency = lerp(frequency_start, frequency_target, t);
    } else {
        frequency = frequency_target;
    }

    if (amplitude_bend_elapsed < amplitude_bend_duration) {
        amplitude_bend_elapsed += delta;
        double t = CLAMP(amplitude_bend_elapsed / amplitude_bend_duration, 0.0, 1.0);
        amplitude = lerp(amplitude_start, amplitude_target, t);
    } else {
        amplitude = amplitude_target;
    }

    double *memory_data_pointer = memory_data.data();
    const u_int32_t *output_routes_pointer = output_routes.data();

    write_memory(0, 0.0,                    memory_data.data()); 
    write_memory(1, frequency,              memory_data.data()); 
    write_memory(2, bool_to_double(pressed), memory_data.data()); 
    write_memory(3, 0.0,                    memory_data.data()); 
    
    for (int i = 0; i < modules.size(); i++) {
        dispatch_table[modules[i].type](modules[i], memory_data_pointer, output_routes_pointer, delta);
    }

    return read_memory(3, memory_data_pointer) * amplitude;
}

// =========================================================
// ======================   HELPERS   ======================
// =========================================================

inline void ModularAudioVoice::write_output(
    uint32_t index,
    double value,
    double* memory_data,
    const uint32_t* output_routes
) {
    memory_data[output_routes[index]] = value;
}

inline double ModularAudioVoice::read_memory(
    uint32_t index,
    double* memory_data
) {
    return memory_data[index];
}

inline void ModularAudioVoice::write_memory(
    uint32_t index,
    double value,
    double* memory_data
) {
    memory_data[index] = value;
}

inline int ModularAudioVoice::double_to_int(double double_p) {
    return static_cast<int>(std::round(double_p));
}

inline bool ModularAudioVoice::double_to_bool(double double_p) {
    return double_p != 0.0;
}

inline double ModularAudioVoice::bool_to_double(bool double_p) {
    return double_p ? 1.0 : 0.0;
}

inline double ModularAudioVoice::int_to_double(int double_p) {
    return static_cast<double>(double_p);
}

inline double ModularAudioVoice::lerp(double a, double b, double t) {
    return a + (b - a) * t;
}

// =========================================================
// INPUT module
//
// Output 1    = frequency : float
// Output 1    = pressed : bool
//
// =========================================================

void ModularAudioVoice::process_input_module(
    const Module &m,
    double* memory_data,
    const uint32_t* output_routes,
    double delta
) {
    double frequency_in = read_memory(1, memory_data);
    double pressed_in    = read_memory(2, memory_data);
    write_output(m.output_offset + 0, frequency_in, memory_data, output_routes);
    write_output(m.output_offset + 1, pressed_in   , memory_data, output_routes);
}

// =====================================================================
// OUTPUT module
//
// Input 0     = sample : float
//
// =====================================================================

void ModularAudioVoice::process_output_module(
    const Module &m,
    double* memory_data,
    const uint32_t* output_routes,
    double delta
) {
    double input_value = read_memory(m.module_offset, memory_data);

    write_memory(3, input_value, memory_data);
}

// =========================================================
// OSCILLATOR module
//
// Input 0     = frequency : float
// State 1     = phase accumulation : float
// Parameter 2 = waveform : enum { SINE, SQUARE, SAW, TRIANGLE }
// Output 0    = sample : float
// 
// =========================================================

void ModularAudioVoice::process_oscillator_module(
    const Module &m,
    double* memory_data,
    const uint32_t* output_routes,
    double delta
) {
    double frequency = read_memory(m.module_offset + 0, memory_data);
    double phase     = read_memory(m.module_offset + 1, memory_data);
    int    waveform  = double_to_int(read_memory(m.module_offset + 2, memory_data));

    double next_phase = std::fmod(phase + Math_TAU * frequency * delta, Math_TAU);
    write_memory(m.module_offset + 1, next_phase, memory_data);

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

    write_output(m.output_offset, sample, memory_data, output_routes);
}

// =========================================================
// NOISE module
//
// Parameter 0 = spectrum : enum { WHITE, PINK, BROWN, VIOLET, }
// Output 0    = sample : float
// 
// =========================================================

void ModularAudioVoice::process_noise_module(
    const Module &m,
    double* memory_data,
    const uint32_t* output_routes,
    double delta
) {

}

// =====================================================================
// ENVELOPE module
//
// Input 0      = gate : bool
// State 1      = level : float
// State 2      = stage : enum { IDLE, ATTACK, DECAY, SUSTAIN, RELEASE }
// State 3      = phase : float
// State 4      = attack_start_level : float
// State 5      = release_start_level : float
// Parameter 6  = attack        : float
// Parameter 7  = decay         : float
// Parameter 8  = sustain       : float
// Parameter 9  = release       : float
// Parameter 10 = attack_curve  : float
// Parameter 11 = decay_curve   : float
// Parameter 12 = release_curve : float
// Parameter 13 = reset         : bool
// Output 0     = output : float
//
// =====================================================================

void ModularAudioVoice::process_envelope_module(
    const Module &m,
    double* memory_data,
    const uint32_t* output_routes,
    double delta
) {
    bool gate                  = double_to_bool(read_memory(m.module_offset + 0, memory_data));
    double level               = read_memory(m.module_offset + 1,  memory_data);
    int stage                  = double_to_int(read_memory(m.module_offset + 2, memory_data));
    double phase               = read_memory(m.module_offset + 3,  memory_data);
    double attack_start_level  = read_memory(m.module_offset + 4,  memory_data);
    double release_start_level = read_memory(m.module_offset + 5,  memory_data);
    double attack              = read_memory(m.module_offset + 6,  memory_data);
    double decay               = read_memory(m.module_offset + 7,  memory_data);
    double sustain             = read_memory(m.module_offset + 8,  memory_data);
    double release             = read_memory(m.module_offset + 9,  memory_data);
    double attack_curve        = read_memory(m.module_offset + 10, memory_data);
    double decay_curve         = read_memory(m.module_offset + 11, memory_data);
    double release_curve       = read_memory(m.module_offset + 12, memory_data);
    bool reset                 = double_to_bool(read_memory(m.module_offset + 13, memory_data));

    // Convert
    attack_curve  = std::pow(12.0, attack_curve * 2.0 - 1.0);
    decay_curve   = std::pow(12.0, decay_curve * 2.0 - 1.0);
    release_curve = std::pow(12.0, release_curve * 2.0 - 1.0);

    // Guard against evil exponenets
    attack_curve  = std::max(attack_curve, 0.001);
    decay_curve   = std::max(decay_curve, 0.001);
    release_curve = std::max(release_curve, 0.001);

    bool entering_attack  = gate  && (stage == 0 || stage == 4);
    bool entering_release = !gate && stage != 0 && stage != 4;

    if (entering_attack)  {
        stage = 1;
        phase = 0.0;
        attack_start_level = level;
        if (reset) {
            level = 0.0;
            attack_start_level = 0.0;
        }
    }
    if (entering_release) {
        stage = 4;
        phase = 0.0;
        release_start_level = level;
    }

    switch (stage) {
        case 0: // Idle
            level = 0.0;
            break;

        case 1: { // Attack: phase 0->1 over attack seconds, level = phase^attack_curve
            phase += delta / std::max(attack, 1e-6);
            if (phase >= 1.0) {
                level = 1.0;
                stage = 2;
                phase = 0.0;
            } else {
                double shaped = std::pow(phase, attack_curve);
                level = attack_start_level + (1.0 - attack_start_level) * shaped;
            }
            break;
        }

        case 2: { // Decay: phase 0->1 over decay seconds, level: 1 -> sustain
            phase += delta / std::max(decay, 1e-6);
            if (phase >= 1.0) {
                level = sustain;
                stage = 3;
            } else {
                double shaped = std::pow(1.0 - phase, decay_curve);
                level = sustain + (1.0 - sustain) * shaped;
            }
            break;
        }

        case 3: // Sustain
            level = sustain;
            break;

        case 4: { // Release: phase 0->1 over release seconds, level: release_start_level -> 0
            phase += delta / std::max(release, 1e-6);
            if (phase >= 1.0) {
                level = 0.0;
                stage = 0;
            } else {
                double shaped = std::pow(1.0 - phase, release_curve);
                level = release_start_level * shaped;
            }
            break;
        }

        default:
            level = 0.0;
            break;
    }

    write_memory(m.module_offset + 1, level, memory_data);
    write_memory(m.module_offset + 2, int_to_double(stage), memory_data);
    write_memory(m.module_offset + 3, phase, memory_data);
    write_memory(m.module_offset + 4, attack_start_level, memory_data);
    write_memory(m.module_offset + 5, release_start_level, memory_data);
    write_output(m.output_offset + 0, level, memory_data, output_routes);
}

// =====================================================================
// FILTER module
//
// Input 0     = audio_in     : float
// State 1     = lowpass      : float
// State 2     = bandpass     : float
// Parameter 3 = cutoff       : float
// Parameter 4 = resonance    : float  (0..1)
// Parameter 5 = filter_mode  : enum    { LP=0, BP=1, HP=2 }
// Output 0    = audio_out    : float
//
// =====================================================================

void ModularAudioVoice::process_filter_module(
    const Module &m,
    double* memory_data,
    const uint32_t* output_routes,
    double delta
) {
    double audio_in    = read_memory(m.module_offset + 0, memory_data);
    double lowpass     = read_memory(m.module_offset + 1, memory_data);
    double bandpass    = read_memory(m.module_offset + 2, memory_data);
    double cutoff      = read_memory(m.module_offset + 3, memory_data);
    double resonance   = read_memory(m.module_offset + 4, memory_data);
    int    filter_mode = double_to_int(read_memory(m.module_offset + 5, memory_data));

    double highpass = 0.0;

    const int iteration_count = 2;
    double iteration_delta = delta / iteration_count;
    double iteration_radians = M_PI * cutoff * iteration_delta;
    double tuning = 2.0 * std::sin(iteration_radians);
    double damping = 2.0 - 2.0 * resonance;

    for (int i = 0; i < iteration_count; ++i) {
        highpass  = audio_in - (damping * bandpass) - lowpass;
        bandpass += tuning * highpass;
        lowpass  += tuning * bandpass;
    }

    double audio_out = 0.0;
    switch (filter_mode) {
        case 0:  audio_out = lowpass;  break;
        case 1:  audio_out = bandpass; break;
        case 2:  audio_out = highpass; break;
        default: audio_out = lowpass;  break;
    }

    write_memory(m.module_offset + 1, lowpass,  memory_data);
    write_memory(m.module_offset + 2, bandpass, memory_data);

    write_output(m.output_offset + 0, audio_out, memory_data, output_routes);
}

// =====================================================================
// BITCRUSHER module
// 
// Input 0     = audio_in : float
// State 1     = sample_hold_value : float
// State 2     = phase_accumulation : float
// Parameter 3 = bit_depth : float
// Parameter 4 = downsample_factor : float
// Parameter 5 = mix : float
// Output 0    = audio_out : float
//
// =====================================================================

void ModularAudioVoice::process_bitcrusher_module(
    const Module &m,
    double* memory_data,
    const uint32_t* output_routes,
    double delta
) {

}

// =====================================================================
// ARITHMETIC module
//
// Input 0     = operand_a : float
// Input 1     = operand_b : float
// Parameter 2 = operation : enum { ADD, SUBTRACT, MULTIPLY, DIVIDE }
// Output 0  = result : float
//
// =====================================================================

void ModularAudioVoice::process_arithmetic_module(
    const Module &m,
    double* memory_data,
    const uint32_t* output_routes,
    double delta
) {
    double a      = read_memory(m.module_offset + 0, memory_data);
    double b      = read_memory(m.module_offset + 1, memory_data);
    int operation = double_to_int(read_memory(m.module_offset + 2, memory_data));

    double result = 0.0;
    switch (operation) {
        case 0: result = a + b;                                break; // Addition
        case 1: result = a - b;                                break; // Subtraction
        case 2: result = a * b;                                break; // Multiplication
        case 3: result = (std::abs(b) > 1e-9) ? a / b : 0.0;   break; // Division
        default: result = 0.0;
    }

    write_output(m.output_offset, result, memory_data, output_routes);
}