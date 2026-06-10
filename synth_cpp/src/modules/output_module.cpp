#include "modules/output_module.h"

void OutputModule::_bind_methods() {
    ClassDB::bind_method(
        D_METHOD("set_audio", "audio"),
        &OutputModule::set_audio
    );
    ClassDB::bind_method(
        D_METHOD("get_audio"),
        &OutputModule::get_audio
    );

    ClassDB::bind_method(
        D_METHOD("set_in_audio", "port"),
        &OutputModule::set_in_audio
    );
    ClassDB::bind_method(
        D_METHOD("get_in_audio"),
        &OutputModule::get_in_audio
    );

    ADD_PROPERTY(
        PropertyInfo(
            Variant::FLOAT,
            "audio"
        ),
        "set_audio",
        "get_audio"
    );
    ADD_PROPERTY(
        PropertyInfo(
            Variant::OBJECT,
            "IN_audio",
            PROPERTY_HINT_RESOURCE_TYPE,
            "Port"
        ),
        "set_in_audio",
        "get_in_audio"
    );
}

OutputModule::OutputModule() {
    inputs.push_back(in_audio);
}

void OutputModule::process(double p_delta) {
    audio = in_audio->get_value();
}

void OutputModule::set_audio(const float &p_audio) {
    audio = p_audio;
}

float OutputModule::get_audio() const {
    return audio;
}

void OutputModule::set_in_audio(const Ref<Port> &p_port) {
    in_audio = p_port;
}

Ref<Port> OutputModule::get_in_audio() const {
    return in_audio;
}