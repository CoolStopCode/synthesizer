#include "port.h"

using namespace godot;

void Port::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_value", "value"), &Port::set_value);
    ClassDB::bind_method(D_METHOD("get_value"), &Port::get_value);

    ADD_PROPERTY(
        PropertyInfo(
            Variant::FLOAT,
            "value"
        ),
        "set_value",
        "get_value"
    );
}

Port::Port() {
    value = 0.0;
}

Port::~Port() {

}

void Port::set_value(double p_value) {
    value = p_value;
}

double Port::get_value() const {
    return value;
}