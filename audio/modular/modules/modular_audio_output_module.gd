class_name ModularAudioOutputModule
extends ModularAudioModule

@export_category("inputs") 
@export var sample : ModularAudioConnection

@export_category("outputs")

@export_group("states")

@export_category("parameters")


func get_type() -> int:
	return 1

func get_inputs() -> Array[ModularAudioConnection]:
	return [sample]

func get_outputs() -> Array[ModularAudioConnection]:
	return []

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
