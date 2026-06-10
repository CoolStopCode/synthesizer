#ifndef OSCILLATOR_MODULE_H
#define OSCILLATOR_MODULE_H

#include "modules/module.h"
#include "port.h"
#include <godot_cpp/classes/curve.hpp>

using namespace godot;

class OscillatorModule : public Module {
    GDCLASS(OscillatorModule, Module);

public:
    enum Waveform {
        WAVEFORM_SINE,
        WAVEFORM_SQUARE,
        WAVEFORM_SAW,
        WAVEFORM_TRIANGLE,
        WAVEFORM_CUSTOM
    };

private:
    int waveform = WAVEFORM_SINE;
    Ref<Curve> curve;

    Ref<Port> in_enabled;
    Ref<Port> in_frequency;
    Ref<Port> out_output;

    double phase = 0.0;

    double evaluate();

protected:
    static void _bind_methods();

public:
    OscillatorModule();

    void process(double p_delta) override;

    void set_waveform(int p_waveform);
    int get_waveform() const;

    void set_curve(const Ref<Curve> &p_curve);
    Ref<Curve> get_curve() const;

    void set_in_enabled(const Ref<Port> &p_port);
    Ref<Port> get_in_enabled() const;

    void set_in_frequency(const Ref<Port> &p_port);
    Ref<Port> get_in_frequency() const;

    void set_out_output(const Ref<Port> &p_port);
    Ref<Port> get_out_output() const;
};

VARIANT_ENUM_CAST(OscillatorModule::Waveform);

#endif