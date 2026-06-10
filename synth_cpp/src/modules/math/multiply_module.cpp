#include "multiply_module.h"

void MultiplyModule::_bind_methods() {
    ClassDB::bind_method(
        D_METHOD("set_in_argument1", "port"),
        &MultiplyModule::set_in_argument1
    );
    ClassDB::bind_method(
        D_METHOD("get_in_argument1"),
        &MultiplyModule::get_in_argument1
    );

    ClassDB::bind_method(
        D_METHOD("set_in_argument2", "port"),
        &MultiplyModule::set_in_argument2
    );
    ClassDB::bind_method(
        D_METHOD("get_in_argument2"),
        &MultiplyModule::get_in_argument2
    );

    ClassDB::bind_method(
        D_METHOD("set_out_output", "port"),
        &MultiplyModule::set_out_output
    );
    ClassDB::bind_method(
        D_METHOD("get_out_output"),
        &MultiplyModule::get_out_output
    );

    ADD_PROPERTY(
        PropertyInfo(
            Variant::OBJECT,
            "IN_argument1",
            PROPERTY_HINT_RESOURCE_TYPE,
            "Port"
        ),
        "set_in_argument1",
        "get_in_argument1"
    );

    ADD_PROPERTY(
        PropertyInfo(
            Variant::OBJECT,
            "IN_argument2",
            PROPERTY_HINT_RESOURCE_TYPE,
            "Port"
        ),
        "set_in_argument2",
        "get_in_argument2"
    );

    ADD_PROPERTY(
        PropertyInfo(
            Variant::OBJECT,
            "OUT_output",
            PROPERTY_HINT_RESOURCE_TYPE,
            "Port"
        ),
        "set_out_output",
        "get_out_output"
    );
}

MultiplyModule::MultiplyModule() {
    inputs.push_back(in_argument1);
    inputs.push_back(in_argument2);

    outputs.push_back(out_output);
}

void MultiplyModule::process(double p_delta) {
    double output = in_argument1->get_value() * in_argument2->get_value();

    out_output->set_value(output);
}

void MultiplyModule::set_in_argument1(const Ref<Port> &p_port) {
    in_argument1 = p_port;
}

Ref<Port> MultiplyModule::get_in_argument1() const {
    return in_argument1;
}

void MultiplyModule::set_in_argument2(const Ref<Port> &p_port) {
    in_argument2 = p_port;
}

Ref<Port> MultiplyModule::get_in_argument2() const {
    return in_argument2;
}

void MultiplyModule::set_out_output(const Ref<Port> &p_port) {
    out_output = p_port;
}

Ref<Port> MultiplyModule::get_out_output() const {
    return out_output;
}