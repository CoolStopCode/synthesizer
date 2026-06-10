#include "modules/input_module.h"

void InputModule::_bind_methods() {
    ClassDB::bind_method(
        D_METHOD("set_active", "active"),
        &InputModule::set_active
    );
    ClassDB::bind_method(
        D_METHOD("get_active"),
        &InputModule::get_active
    );

    ClassDB::bind_method(
        D_METHOD("set_frequency", "frequency"),
        &InputModule::set_frequency
    );
    ClassDB::bind_method(
        D_METHOD("get_frequency"),
        &InputModule::get_frequency
    );

    ClassDB::bind_method(
        D_METHOD("set_out_active", "port"),
        &InputModule::set_out_active
    );
    ClassDB::bind_method(
        D_METHOD("get_out_active"),
        &InputModule::get_out_active
    );

    ClassDB::bind_method(
        D_METHOD("set_out_frequency", "port"),
        &InputModule::set_out_frequency
    );
    ClassDB::bind_method(
        D_METHOD("get_out_frequency"),
        &InputModule::get_out_frequency
    );

    ADD_PROPERTY(
        PropertyInfo(
            Variant::BOOL,
            "active"
        ),
        "set_active",
        "get_active"
    );
    ADD_PROPERTY(
        PropertyInfo(
            Variant::FLOAT,
            "frequency"
        ),
        "set_frequency",
        "get_frequency"
    );
    ADD_PROPERTY(
        PropertyInfo(
            Variant::OBJECT,
            "OUT_active",
            PROPERTY_HINT_RESOURCE_TYPE,
            "Port"
        ),
        "set_out_active",
        "get_out_active"
    );
    ADD_PROPERTY(
        PropertyInfo(
            Variant::OBJECT,
            "OUT_frequency",
            PROPERTY_HINT_RESOURCE_TYPE,
            "Port"
        ),
        "set_out_frequency",
        "get_out_frequency"
    );
}

InputModule::InputModule() {
    outputs.push_back(out_active);
    outputs.push_back(out_frequency);
}

void InputModule::process(double p_delta) {
    out_active->set_value(active);
    out_frequency->set_value(frequency);
}

void InputModule::set_active(const bool &p_active) {
    active = p_active;
}

bool InputModule::get_active() const {
    return active;
}

void InputModule::set_frequency(const float &p_frequency) {
    frequency = p_frequency;
}

float InputModule::get_frequency() const {
    return frequency;
}

void InputModule::set_out_active(const Ref<Port> &p_port) {
    out_active = p_port;
}

Ref<Port> InputModule::get_out_active() const {
    return out_active;
}

void InputModule::set_out_frequency(const Ref<Port> &p_port) {
    out_frequency = p_port;
}

Ref<Port> InputModule::get_out_frequency() const {
    return out_frequency;
}