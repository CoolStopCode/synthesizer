class_name ModularAudioInputModule
extends ModularAudioModule

@export_category("inputs") 


@export_category("outputs")
@export var frequency : ModularAudioConnection
@export var active : ModularAudioConnection

@export_group("states")


@export_category("parameters")


func get_type() -> int:
	return 0

func get_inputs() -> Array[ModularAudioConnection]:
	return []

func get_outputs() -> Array[ModularAudioConnection]:
	return [frequency, active]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
