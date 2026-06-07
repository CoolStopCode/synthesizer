class_name Voice
extends RefCounted

var input_module : InputModule
var output_module : OutputModule

var modules: Array[Module] = []

func voice_on() -> void:
	input_module.active = true

func voice_off() -> void:
	input_module.active = false

func process(delta: float) -> float:
	for module in modules:
		module.process(delta)
	
	var output : float = output_module.audio
	return output;
