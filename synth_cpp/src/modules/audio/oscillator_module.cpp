#include "oscillator_module.h"
#include <godot_cpp/core/math.hpp>

void OscillatorModule::_bind_methods() {
    BIND_ENUM_CONSTANT(WAVEFORM_SINE);
    BIND_ENUM_CONSTANT(WAVEFORM_SQUARE);
    BIND_ENUM_CONSTANT(WAVEFORM_SAW);
    BIND_ENUM_CONSTANT(WAVEFORM_TRIANGLE);
    BIND_ENUM_CONSTANT(WAVEFORM_CUSTOM);

    ClassDB::bind_method(D_METHOD("set_waveform", "waveform"), &OscillatorModule::set_waveform);
    ClassDB::bind_method(D_METHOD("get_waveform"), &OscillatorModule::get_waveform);

    ClassDB::bind_method(D_METHOD("set_curve", "curve"), &OscillatorModule::set_curve);
    ClassDB::bind_method(D_METHOD("get_curve"), &OscillatorModule::get_curve);

    ClassDB::bind_method(D_METHOD("set_in_enabled", "port"), &OscillatorModule::set_in_enabled);
    ClassDB::bind_method(D_METHOD("get_in_enabled"), &OscillatorModule::get_in_enabled);

    ClassDB::bind_method(D_METHOD("set_in_frequency", "port"), &OscillatorModule::set_in_frequency);
    ClassDB::bind_method(D_METHOD("get_in_frequency"), &OscillatorModule::get_in_frequency);

    ClassDB::bind_method(D_METHOD("set_out_output", "port"), &OscillatorModule::set_out_output);
    ClassDB::bind_method(D_METHOD("get_out_output"), &OscillatorModule::get_out_output);

    ADD_PROPERTY(PropertyInfo(Variant::INT, "waveform", PROPERTY_HINT_ENUM, "Sine,Square,Saw,Triangle,Custom"), "set_waveform", "get_waveform");
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "curve", PROPERTY_HINT_RESOURCE_TYPE, "Curve"), "set_curve", "get_curve");

    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "IN_enabled", PROPERTY_HINT_RESOURCE_TYPE, "Port"), "set_in_enabled", "get_in_enabled");
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "IN_frequency", PROPERTY_HINT_RESOURCE_TYPE, "Port"), "set_in_frequency", "get_in_frequency");
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "OUT_output", PROPERTY_HINT_RESOURCE_TYPE, "Port"), "set_out_output", "get_out_output");
}

OscillatorModule::OscillatorModule() {
    inputs.push_back(in_enabled);
    inputs.push_back(in_frequency);

    outputs.push_back(out_output);
}

void OscillatorModule::process(double p_delta) {
    phase += in_frequency->get_value() * p_delta;
    phase = Math::fmod(phase, 1.0);
    if (phase < 0.0) phase += 1.0;

    double output = evaluate();

    out_output->set_value(output);
}

double OscillatorModule::evaluate() {
    double amplitude = 0.0;

    switch (waveform) {
        case WAVEFORM_SINE:
            amplitude = Math::sin(phase * Math_TAU);
            break;
        case WAVEFORM_SQUARE:
            amplitude = (phase < 0.5) ? 1.0 : -1.0;
            break;
        case WAVEFORM_SAW:
            amplitude = (phase * 2.0) - 1.0;
            break;
        case WAVEFORM_TRIANGLE:
            amplitude = 1.0 - 4.0 * Math::abs(phase - 0.5);
            break;
        case WAVEFORM_CUSTOM:
            if (curve.is_valid()) {
                amplitude = curve->sample(phase);
            } else {
                amplitude = 0.0;
            }
            break;
        default:
            amplitude = 0.0;
            break;
    }

    return amplitude;
}

void OscillatorModule::set_waveform(int p_waveform) { waveform = p_waveform; }
int OscillatorModule::get_waveform() const { return waveform; }

void OscillatorModule::set_curve(const Ref<Curve> &p_curve) { curve = p_curve; }
Ref<Curve> OscillatorModule::get_curve() const { return curve; }

void OscillatorModule::set_in_enabled(const Ref<Port> &p_port) { in_enabled = p_port; }
Ref<Port> OscillatorModule::get_in_enabled() const { return in_enabled; }

void OscillatorModule::set_in_frequency(const Ref<Port> &p_port) { in_frequency = p_port; }
Ref<Port> OscillatorModule::get_in_frequency() const { return in_frequency; }

void OscillatorModule::set_out_output(const Ref<Port> &p_port) { out_output = p_port; }
Ref<Port> OscillatorModule::get_out_output() const { return out_output; }