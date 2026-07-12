class_name Node_ConstantModule
extends Node_Module

@export_category("inputs") 

@export_category("outputs")
@export var output : Node_Connection

@export_group("states")

@export_category("parameters")
@export var value : float

func get_type() -> int:
	return -1

func get_inputs() -> Array[Node_Connection]:
	return []

func get_outputs() -> Array[Node_Connection]:
	return [output]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [value]
