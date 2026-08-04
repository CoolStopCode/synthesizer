class_name ModularOutputModule
extends ModularModule

@export_category("inputs") 
@export var sample : ModularConnection

@export_category("outputs")

@export_group("states")

@export_category("parameters")


func get_type() -> int:
	return 1

func get_inputs() -> Array[ModularConnection]:
	return [sample]

func get_outputs() -> Array[ModularConnection]:
	return []

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
