class_name Node_OutputModule
extends Node_Module

@export_category("inputs") 
@export var sample : Node_Connection

@export_category("outputs")

@export_group("states")

@export_category("parameters")


func get_type() -> int:
	return 1

func get_inputs() -> Array[Node_Connection]:
	return [sample]

func get_outputs() -> Array[Node_Connection]:
	return []

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
