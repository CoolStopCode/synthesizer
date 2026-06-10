#ifndef PORT_H
#define PORT_H

#include <godot_cpp/classes/resource.hpp>

using namespace godot;

class Port : public Resource {
    GDCLASS(Port, Resource);

protected:
    static void _bind_methods();

    double value = 0.0;

public:
    Port();
    ~Port();

    void set_value(double p_value);
    double get_value() const;

    operator bool() const { return value != 0.0; }
};

#endif