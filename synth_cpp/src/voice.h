#ifndef VOICE_H
#define VOICE_H

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/variant/typed_array.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class Voice : public Resource {
    GDCLASS(Voice, Resource)

private:
    Ref<Resource> input_module;
    Ref<Resource> output_module;
    TypedArray<Resource> modules;

protected:
    static void _bind_methods();

public:
    void set_input_module(const Ref<Resource> &p_module);
    Ref<Resource> get_input_module() const;

    void set_output_module(const Ref<Resource> &p_module);
    Ref<Resource> get_output_module() const;

    void set_modules(const TypedArray<Resource> &p_modules);
    TypedArray<Resource> get_modules() const;

    void voice_on();
    void voice_off();

    double process(double delta);
};

#endif