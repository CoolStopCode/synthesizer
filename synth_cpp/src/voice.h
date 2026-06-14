#ifndef VOICE_H
#define VOICE_H

#include <array>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/packed_float32_array.hpp>
#include <godot_cpp/variant/packed_int32_array.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class Voice : public RefCounted {
    GDCLASS(Voice, RefCounted)

public:
    enum ModuleType : uint8_t {
        INPUT,
        OSCILLATOR,
        ENVELOPE,
        ARITHMETIC,
        OUTPUT,
        MODULE_TYPE_COUNT
    };

    struct Module {
        uint8_t type;

        // === GET ===
        uint32_t input_offset; // start of inputs in connections
        uint32_t input_count; // length of inputs in connections

        // === SET ===
        uint32_t output_offset; // start of outputs in connections
        uint32_t output_count; // length of outputs in connections

        // === PRIVATE ===
        uint32_t state_offset; // start of states in states
        uint32_t state_count; // length of states in states

        // === CONSTANT ===
        uint32_t parameter_offset; // start of parameters in parameters
        uint32_t parameter_count; // length of parameters in parameters
    };

    using ModuleFunction = void(*)(const Module& module, Vector<double>& connections, Vector<double>& states, Vector<double>& parameters, double delta);

private:
    double frequency = 0.0; // in
    bool active = false;

    double sample = 0.0; // out

    Vector<double> connections;
    Vector<double> states;
    Vector<double> parameters;
    Vector<Module> modules;

    static std::array<ModuleFunction, MODULE_TYPE_COUNT> dispatch_table;

public:
    Voice() {}
    ~Voice() {}

    void set_frequency(const double frequency_p);
    double get_frequency();

    void set_active(const bool active_p);
    bool get_active();

    void set_graph(
        const PackedByteArray &types,

        const PackedInt32Array &input_offsets,
        const PackedInt32Array &input_counts,

        const PackedInt32Array &output_offsets,
        const PackedInt32Array &output_counts,

        const PackedInt32Array &state_offsets,
        const PackedInt32Array &state_counts,

        const PackedInt32Array &parameter_offsets,
        const PackedInt32Array &parameter_counts,

        const PackedFloat64Array &parameter_values
    );

    double process(double delta);

private:
    static void _bind_methods();
    static void process_input_module(       const Module&, Vector<double>&, Vector<double>&, Vector<double>&, double);
    static void process_oscillator_module(  const Module&, Vector<double>&, Vector<double>&, Vector<double>&, double);
    static void process_envelope_module(    const Module&, Vector<double>&, Vector<double>&, Vector<double>&, double);
    static void process_arithmetic_module(  const Module&, Vector<double>&, Vector<double>&, Vector<double>&, double);
    static void process_output_module(      const Module&, Vector<double>&, Vector<double>&, Vector<double>&, double);
};

#endif