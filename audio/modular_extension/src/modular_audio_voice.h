#ifndef MODULAR_VOICE_H
#define MODULAR_VOICE_H

#include <array>
#include <vector>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/packed_float32_array.hpp>
#include <godot_cpp/variant/packed_int32_array.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>
#include <godot_cpp/core/math_defs.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class ModularAudioVoice : public RefCounted {
    GDCLASS(ModularAudioVoice, RefCounted)

public:
    enum ModuleType : uint8_t {
        INPUT,
        OUTPUT,

        OSCILLATOR,
        NOISE,

        ENVELOPE,
        FILTER,
        BITCRUSHER,

        ARITHMETIC,

        MODULE_TYPE_COUNT
    };

    struct Module {
        uint8_t  type;

        uint32_t module_offset; // States, parameters, inputs
        uint32_t output_offset; // Outputs (redirected through output_routes)
    };

    using ModuleFunction = void (*)(
        const Module&   module,
        double*         memory_data,
        const uint32_t* output_routes,
        double          delta
    );

private:
    double frequency               = 0.0;
    double frequency_start         = 0.0;
    double frequency_target        = 0.0;
    double frequency_bend_duration = 0.0;
    double frequency_bend_elapsed  = 0.0;

    double amplitude               = 0.0;
    double amplitude_start         = 0.0;
    double amplitude_target        = 0.0;
    double amplitude_bend_duration = 0.0;
    double amplitude_bend_elapsed  = 0.0;

    bool active = false;

    // memory_data[0]:  unused
    // memory_data[1]:  frequency input
    // memory_data[2]:  active input
    // memory_data[3]:  sample output
    // memory_data[4+]: module use (outputs, states, parameters)
    std::vector<double>   memory_data;
    std::vector<uint32_t> output_routes;
    std::vector<Module>   modules;

    // Bindings of module process function to module type.
    static std::array<ModuleFunction, MODULE_TYPE_COUNT> dispatch_table;

public:
    ModularAudioVoice() = default;
    ~ModularAudioVoice() = default;

    void   set_frequency(double frequency_p); // memory_data[1]
    double get_frequency();
    void   bend_frequency_to(double target, double duration);

    void   set_amplitude(double amplitude_p);
    double get_amplitude();
    void   bend_amplitude_to(double target, double duration);

    void set_active(bool active_p); // memory_data[2]
    bool get_active();

    void set_layout(
        const PackedByteArray&    types, // Array of ModuleType

        const PackedInt32Array&   module_offsets,
        const PackedInt32Array&   output_offsets,

        const PackedInt32Array&   output_routes, // Array of memory_data indices
        const PackedFloat64Array& memory_data     // memory_data
    );

    double process(double delta);

private:
    static void _bind_methods();

    static inline void   write_output(uint32_t index, double value, double* memory_data, const uint32_t* output_routes);
    static inline double read_memory( uint32_t index,               double* memory_data                               );
    static inline void   write_memory(uint32_t index, double value, double* memory_data                               );

    static inline int    double_to_int(double value);
    static inline bool   double_to_bool(double value);
    static inline double bool_to_double(bool value);
    static inline double int_to_double(int value);
    static inline double lerp(double a, double b, double t);

    static void process_input_module(     const Module& module, double* memory_data, const uint32_t* output_routes, double delta);
    static void process_output_module(    const Module& module, double* memory_data, const uint32_t* output_routes, double delta);
    static void process_oscillator_module(const Module& module, double* memory_data, const uint32_t* output_routes, double delta);
    static void process_noise_module(     const Module& module, double* memory_data, const uint32_t* output_routes, double delta);
    static void process_envelope_module(  const Module& module, double* memory_data, const uint32_t* output_routes, double delta);
    static void process_filter_module(    const Module& module, double* memory_data, const uint32_t* output_routes, double delta);
    static void process_bitcrusher_module(const Module& module, double* memory_data, const uint32_t* output_routes, double delta);
    static void process_arithmetic_module(const Module& module, double* memory_data, const uint32_t* output_routes, double delta);
};

#endif