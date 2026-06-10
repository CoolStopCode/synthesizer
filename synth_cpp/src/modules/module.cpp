#include "modules/module.h"

void Module::_bind_methods() {
    ClassDB::bind_method(D_METHOD("process", "delta"), &Module::process);

    ClassDB::bind_method(D_METHOD("set_inputs", "inputs"), &Module::set_inputs);
    ClassDB::bind_method(D_METHOD("get_inputs"), &Module::get_inputs);

    ClassDB::bind_method(D_METHOD("set_outputs", "outputs"), &Module::set_outputs);
    ClassDB::bind_method(D_METHOD("get_outputs"), &Module::get_outputs);

    ADD_PROPERTY(
        PropertyInfo(
            Variant::ARRAY, 
            "inputs", 
            PROPERTY_HINT_ARRAY_TYPE, 
            "Port"
        ), 
        "set_inputs", 
        "get_inputs"
    );
    ADD_PROPERTY(
        PropertyInfo(
            Variant::ARRAY, 
            "outputs", 
            PROPERTY_HINT_ARRAY_TYPE, 
            "Port"
        ), 
        "set_outputs", 
        "get_outputs"
    );
}

void Module::process(double delta) {}

void Module::set_inputs(const TypedArray<Port> &p_inputs) {
    inputs = p_inputs;
}
TypedArray<Port> Module::get_inputs() const {
    return inputs;
}

void Module::set_outputs(const TypedArray<Port> &p_outputs) {
    outputs = p_outputs;
}
TypedArray<Port> Module::get_outputs() const {
    return outputs;
}