class_name Modular_OutputModule
extends Modular_Module

@export_category("inputs") 
@export var sample : Modular_Connection

@export_category("outputs")

@export_group("states")

@export_category("parameters")


func get_type() -> int:
	return 1

func get_inputs() -> Array[Modular_Connection]:
	return [sample]

func get_outputs() -> Array[Modular_Connection]:
	return []

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
