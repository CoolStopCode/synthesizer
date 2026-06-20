class_name Node_InputModule
extends Node_Module

@export_category("inputs") 


@export_category("outputs")
@export var frequency : Node_Connection
@export var active : Node_Connection

@export_category("states")


@export_category("parameters")


func get_type() -> int:
	return 0

func get_inputs() -> Array[Node_Connection]:
	return []

func get_outputs() -> Array[Node_Connection]:
	return [frequency, active]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
