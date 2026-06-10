#ifndef MODULE_H
#define MODULE_H

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/variant/typed_array.hpp>
#include <godot_cpp/core/class_db.hpp>
#include "port.h"

using namespace godot;

class Module : public Resource {
    GDCLASS(Module, Resource);

private:
    

protected:
    static void _bind_methods();

    TypedArray<Port> inputs;
    TypedArray<Port> outputs;

public:
    void set_inputs(const TypedArray<Port> &p_inputs);
    TypedArray<Port> get_inputs() const;

    void set_outputs(const TypedArray<Port> &p_outputs);
    TypedArray<Port> get_outputs() const;

    virtual void process(double delta);
};

#endif