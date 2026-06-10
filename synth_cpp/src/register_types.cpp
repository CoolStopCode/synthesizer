#include "register_types.h"

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

#include "voice.h"
#include "port.h"

#include "modules/module.h"
#include "modules/audio/envelope_module.h"
// #include "modules/equilizer_module.h"
#include "modules/audio/oscillator_module.h"
#include "modules/math/multiply_module.h"
#include "modules/input_module.h"
#include "modules/output_module.h"

using namespace godot;

void initialize_synth(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

	ClassDB::register_class<Port>();

	ClassDB::register_class<Module>();
	ClassDB::register_class<EnvelopeModule>();
	ClassDB::register_class<OscillatorModule>();
	ClassDB::register_class<MultiplyModule>();
	ClassDB::register_class<InputModule>();
	ClassDB::register_class<OutputModule>();
	
	ClassDB::register_class<Voice>();
}

void uninitialize_synth(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
}

extern "C" {

// This is the entry point Godot calls
GDExtensionBool GDE_EXPORT synth_init(
	GDExtensionInterfaceGetProcAddress p_get_proc_address,
	const GDExtensionClassLibraryPtr p_library,
	GDExtensionInitialization *r_initialization
) {
	godot::GDExtensionBinding::InitObject init_obj(
		p_get_proc_address,
		p_library,
		r_initialization
	);

	init_obj.register_initializer(initialize_synth);
	init_obj.register_terminator(uninitialize_synth);
	init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

	return init_obj.init();
}

}