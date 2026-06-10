class_name GDVoice
extends Resource

@export var input_module : GDInputModule
@export var output_module : GDOutputModule

@export var modules: Array[GDModule] = []

func voice_on() -> void:
	input_module.active = true

func voice_off() -> void:
	input_module.active = false

func process(delta: float) -> float:
	for module in modules:
		module.process(delta)
	
	var output : float = output_module.audio
	return output;
