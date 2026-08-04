class_name ModularInputModule
extends ModularModule

@export_category("inputs") 


@export_category("outputs")
@export var frequency : ModularConnection
@export var active : ModularConnection

@export_group("states")


@export_category("parameters")


func get_type() -> int:
	return 0

func get_inputs() -> Array[ModularConnection]:
	return []

func get_outputs() -> Array[ModularConnection]:
	return [frequency, active]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
