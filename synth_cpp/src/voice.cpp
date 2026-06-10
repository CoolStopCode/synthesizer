#include "voice.h"

void Voice::_bind_methods() {
    ClassDB::bind_method(D_METHOD("voice_on"), &Voice::voice_on);
    ClassDB::bind_method(D_METHOD("voice_off"), &Voice::voice_off);
    ClassDB::bind_method(D_METHOD("process", "delta"), &Voice::process);

    ClassDB::bind_method(D_METHOD("set_input_module", "module"), &Voice::set_input_module);
    ClassDB::bind_method(D_METHOD("get_input_module"), &Voice::get_input_module);

    ClassDB::bind_method(D_METHOD("set_output_module", "module"), &Voice::set_output_module);
    ClassDB::bind_method(D_METHOD("get_output_module"), &Voice::get_output_module);

    ClassDB::bind_method(D_METHOD("set_modules", "modules"), &Voice::set_modules);
    ClassDB::bind_method(D_METHOD("get_modules"), &Voice::get_modules);

    ADD_PROPERTY(
        PropertyInfo(
            Variant::OBJECT, 
            "input_module"
        ),
        "set_input_module",
        "get_input_module"
    );

    ADD_PROPERTY(
        PropertyInfo(
            Variant::OBJECT,
            "output_module"
        ),
        "set_output_module",
        "get_output_module"
    );

    ADD_PROPERTY(
        PropertyInfo(
            Variant::ARRAY,
            "modules"
        ),
        "set_modules",
        "get_modules"
    );
}

void Voice::voice_on() {
    if (input_module.is_valid()) {
        input_module->set("active", true);
    }
}

void Voice::voice_off() {
    if (input_module.is_valid()) {
        input_module->set("active", false);
    }
}

double Voice::process(double delta) {
    for (int i = 0; i < modules.size(); i++) {
        Ref<Resource> module = modules[i];
        if (module.is_valid()) {
            module->call("process", delta);
        }
    }

    double output = 0.0;

    if (output_module.is_valid()) {
        output = output_module->get("audio");
    }

    return output;
}

void Voice::set_input_module(const Ref<Resource> &p_module) { input_module = p_module; }
Ref<Resource> Voice::get_input_module() const { return input_module; }

void Voice::set_output_module(const Ref<Resource> &p_module) { output_module = p_module; }
Ref<Resource> Voice::get_output_module() const { return output_module; }

void Voice::set_modules(const TypedArray<Resource> &p_modules) { modules = p_modules; }
TypedArray<Resource> Voice::get_modules() const { return modules; }