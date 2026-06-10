#include "envelope_module.h"
#include <algorithm>

void EnvelopeModule::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_attack", "attack"), &EnvelopeModule::set_attack);
    ClassDB::bind_method(D_METHOD("get_attack"), &EnvelopeModule::get_attack);

    ClassDB::bind_method(D_METHOD("set_decay", "decay"), &EnvelopeModule::set_decay);
    ClassDB::bind_method(D_METHOD("get_decay"), &EnvelopeModule::get_decay);

    ClassDB::bind_method(D_METHOD("set_sustain", "sustain"), &EnvelopeModule::set_sustain);
    ClassDB::bind_method(D_METHOD("get_sustain"), &EnvelopeModule::get_sustain);

    ClassDB::bind_method(D_METHOD("set_release", "release"), &EnvelopeModule::set_release);
    ClassDB::bind_method(D_METHOD("get_release"), &EnvelopeModule::get_release);

    ClassDB::bind_method(D_METHOD("set_velocity", "velocity"), &EnvelopeModule::set_velocity);
    ClassDB::bind_method(D_METHOD("get_velocity"), &EnvelopeModule::get_velocity);

    ClassDB::bind_method(D_METHOD("set_in_active", "port"), &EnvelopeModule::set_in_active);
    ClassDB::bind_method(D_METHOD("get_in_active"), &EnvelopeModule::get_in_active);

    ClassDB::bind_method(D_METHOD("set_out_output", "port"), &EnvelopeModule::set_out_output);
    ClassDB::bind_method(D_METHOD("get_out_output"), &EnvelopeModule::get_out_output);

    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "attack"), "set_attack", "get_attack");
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "decay"), "set_decay", "get_decay");
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "sustain"), "set_sustain", "get_sustain");
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "release"), "set_release", "get_release");
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "velocity"), "set_velocity", "get_velocity");

    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "IN_active", PROPERTY_HINT_RESOURCE_TYPE, "Port"), "set_in_active", "get_in_active");
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "OUT_output", PROPERTY_HINT_RESOURCE_TYPE, "Port"), "set_out_output", "get_out_output");
}

EnvelopeModule::EnvelopeModule() {
    inputs.push_back(in_active);
    outputs.push_back(out_output);
}

void EnvelopeModule::process(double p_delta) {
    bool active = in_active->get_value();

    if (!active && state == STATE_IDLE) {
        out_output->set_value(0.0);
        return;
    }

    if (active) {
        if (state == STATE_IDLE || state == STATE_RELEASE) {
            state = STATE_ATTACK;
        }
    } else if (state != STATE_IDLE && state != STATE_RELEASE) {
        state = STATE_RELEASE;
    }

    switch (state) {
        case STATE_IDLE:
            out_output->set_value(0.0);
            return;

        case STATE_ATTACK:
            output += p_delta / std::max(attack, 0.0001);
            if (output >= velocity) {
                output = velocity;
                state = STATE_DECAY;
            }
            break;

        case STATE_DECAY:
            output -= p_delta * ((velocity - sustain) / std::max(decay, 0.0001));
            if (output <= sustain) {
                output = sustain;
                state = STATE_SUSTAIN;
            }
            break;

        case STATE_SUSTAIN:
            output = sustain;
            break;

        case STATE_RELEASE:
            output -= p_delta / std::max(release, 0.0001);
            if (output <= 0.0) {
                output = 0.0;
                state = STATE_IDLE;
            }
            break;
    }

    out_output->set_value(output);
}

void EnvelopeModule::set_attack(double p_attack) { attack = p_attack; }
double EnvelopeModule::get_attack() const { return attack; }

void EnvelopeModule::set_decay(double p_decay) { decay = p_decay; }
double EnvelopeModule::get_decay() const { return decay; }

void EnvelopeModule::set_sustain(double p_sustain) { sustain = p_sustain; }
double EnvelopeModule::get_sustain() const { return sustain; }

void EnvelopeModule::set_release(double p_release) { release = p_release; }
double EnvelopeModule::get_release() const { return release; }

void EnvelopeModule::set_velocity(double p_velocity) { velocity = p_velocity; }
double EnvelopeModule::get_velocity() const { return velocity; }

void EnvelopeModule::set_in_active(const Ref<Port> &p_port) { in_active = p_port; }
Ref<Port> EnvelopeModule::get_in_active() const { return in_active; }

void EnvelopeModule::set_out_output(const Ref<Port> &p_port) { out_output = p_port; }
Ref<Port> EnvelopeModule::get_out_output() const { return out_output; }