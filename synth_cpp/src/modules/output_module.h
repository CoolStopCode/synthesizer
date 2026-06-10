#ifndef OUTPUT_MODULE_H
#define OUTPUT_MODULE_H

#include "modules/module.h"
#include "port.h"

using namespace godot;

class OutputModule : public Module {
    GDCLASS(OutputModule, Module);

private:
    float audio;
    Ref<Port> in_audio;

protected:
    static void _bind_methods();

public:
    OutputModule();

    void process(double p_delta) override;

    void set_audio(const float &p_audio);
    float get_audio() const;

    void set_in_audio(const Ref<Port> &p_audio);
    Ref<Port> get_in_audio() const;
};

#endif