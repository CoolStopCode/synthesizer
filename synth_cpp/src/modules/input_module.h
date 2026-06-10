#ifndef INPUT_MODULE_H
#define INPUT_MODULE_H

#include "modules/module.h"
#include "port.h"

using namespace godot;

class InputModule : public Module {
    GDCLASS(InputModule, Module);

private:
    bool active;
    float frequency;
    Ref<Port> out_active;
    Ref<Port> out_frequency;

protected:
    static void _bind_methods();

public:
    InputModule();

    void process(double p_delta) override;

    void set_active(const bool &p_active);
    bool get_active() const;

    void set_frequency(const float &p_frequency);
    float get_frequency() const;

    void set_out_active(const Ref<Port> &p_port);
    Ref<Port> get_out_active() const;

    void set_out_frequency(const Ref<Port> &p_port);
    Ref<Port> get_out_frequency() const;
};

#endif