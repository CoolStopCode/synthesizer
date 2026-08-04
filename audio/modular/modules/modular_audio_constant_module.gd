class_name ModularAudioConstantModule
extends ModularAudioModule

@export_category("inputs") 

@export_category("outputs")
@export var output : ModularAudioConnection

@export_group("states")

@export_category("parameters")
@export var value : float

func get_type() -> int:
	return -1

func get_inputs() -> Array[ModularAudioConnection]:
	return []

func get_outputs() -> Array[ModularAudioConnection]:
	return [output]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [value]
