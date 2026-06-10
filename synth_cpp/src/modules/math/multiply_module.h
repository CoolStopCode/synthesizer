#ifndef MULTIPLY_MODULE_H
#define MULTIPLY_MODULE_H

#include "modules/module.h"
#include "port.h"

using namespace godot;

class MultiplyModule : public Module {
    GDCLASS(MultiplyModule, Module);

private:
    Ref<Port> in_argument1;
    Ref<Port> in_argument2;
    Ref<Port> out_output;

protected:
    static void _bind_methods();

public:
    MultiplyModule();

    void process(double p_delta) override;

    void set_in_argument1(const Ref<Port> &p_port);
    Ref<Port> get_in_argument1() const;

    void set_in_argument2(const Ref<Port> &p_port);
    Ref<Port> get_in_argument2() const;

    void set_out_output(const Ref<Port> &p_port);
    Ref<Port> get_out_output() const;
};

#endif