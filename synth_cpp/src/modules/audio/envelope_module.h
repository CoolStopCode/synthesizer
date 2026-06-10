#ifndef ENVELOPE_MODULE_H
#define ENVELOPE_MODULE_H

#include "modules/module.h"
#include "port.h"

using namespace godot;

class EnvelopeModule : public Module {
    GDCLASS(EnvelopeModule, Module);

public:
    enum State {
        STATE_IDLE,
        STATE_ATTACK,
        STATE_DECAY,
        STATE_SUSTAIN,
        STATE_RELEASE
    };

private:
    double attack = 0.1;
    double decay = 0.1;
    double sustain = 0.5;
    double release = 0.1;
    double velocity = 1.0;

    Ref<Port> in_active;
    Ref<Port> out_output;

    double output = 0.0;
    State state = STATE_IDLE;

protected:
    static void _bind_methods();

public:
    EnvelopeModule();

    void process(double p_delta) override;

    void set_attack(double p_attack);
    double get_attack() const;

    void set_decay(double p_decay);
    double get_decay() const;

    void set_sustain(double p_sustain);
    double get_sustain() const;

    void set_release(double p_release);
    double get_release() const;

    void set_velocity(double p_velocity);
    double get_velocity() const;

    void set_in_active(const Ref<Port> &p_port);
    Ref<Port> get_in_active() const;

    void set_out_output(const Ref<Port> &p_port);
    Ref<Port> get_out_output() const;
};

#endif