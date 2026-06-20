#ifndef NODE_VOICE_H
#define NODE_VOICE_H

#include <array>
#include <vector>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/packed_float32_array.hpp>
#include <godot_cpp/variant/packed_int32_array.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>
#include <godot_cpp/core/math_defs.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class Node_Voice : public RefCounted {
    GDCLASS(Node_Voice, RefCounted)

public:
    enum ModuleType : uint8_t {
        INPUT,
        OUTPUT,

        OSCILLATOR,
        NOISE,

        ENVELOPE,
        EQUALIZER,
        BITCRUSHER,

        ARITHMETIC,

        MODULE_TYPE_COUNT
    };

    struct Module {
        uint8_t type;

        // Read memory_data[input_routes[offset + i]
        uint32_t input_offset;

        // Write memory_data[offset + i]
        uint32_t output_offset;

        // Read & write memory_data[offset + i]
        uint32_t state_offset;

        // Read memory_data[offset + i]
        uint32_t parameter_offset;
    };

    using ModuleFunction = void(*)(
        const Module& m,
        double* memory_data,
        const uint32_t* input_routes,
        double delta
    );

private:
    bool active = false;
    double frequency = 440.0;
    // memory_data[0]:  wrote to by empty connections, never read
    // memory_data[1]:  frequency input
    // memory_data[2]:  active input
    // memory_data[3]:  sample output
    // memory_data[4+]: module use (outputs, states, parameters)
    std::vector<double> memory_data;
    std::vector<uint32_t> input_routes;
    std::vector<Module> modules;

    // bindings of module process function to module
    static std::array<ModuleFunction, MODULE_TYPE_COUNT> dispatch_table;

public:
    Node_Voice() {} // Constructor
    ~Node_Voice() {} // Destructor

    void set_frequency(const double frequency_p); // memory_data[1]
    double get_frequency();

    void set_active(const bool active_p); // memory_data[2]
    bool get_active();

    void set_layout(
        const PackedByteArray &types, // Array of ModuleType

        const PackedInt32Array &input_offsets,
        const PackedInt32Array &output_offsets,
        const PackedInt32Array &state_offsets,
        const PackedInt32Array &parameter_offsets,
        
        const PackedInt32Array &input_routes, // Array of memory_data indices
        const PackedFloat64Array &initial_memory_data // memory_data
    );

    double process(double delta);

private:
    static void _bind_methods();

    static inline double read_input(uint32_t index, double* memory_data, const uint32_t* input_routes); // memory_data[input_routes[i]]
    static inline double read_memory(uint32_t index, double* memory_data); // memory_data[i]
    static inline void write_memory(uint32_t index, double value, double* memory_data); // memory_data[i]

    static inline int double_to_int(double double_p);
    static inline bool double_to_bool(double double_p);
    static inline double bool_to_double(bool double_p);
    static inline double int_to_double(int double_p);

    static void process_input_module(       const Module&, double*, const uint32_t*, double);
    static void process_output_module(      const Module&, double*, const uint32_t*, double);
    static void process_oscillator_module(  const Module&, double*, const uint32_t*, double);
    static void process_noise_module(       const Module&, double*, const uint32_t*, double);

    static void process_envelope_module(    const Module&, double*, const uint32_t*, double);
    static void process_equalizer_module(   const Module&, double*, const uint32_t*, double);
    static void process_bitcrusher_module(  const Module&, double*, const uint32_t*, double);

    static void process_arithmetic_module(  const Module&, double*, const uint32_t*, double);
};

#endif