class_name Modular_InputModule
extends Modular_Module

@export_category("inputs") 


@export_category("outputs")
@export var frequency : Modular_Connection
@export var active : Modular_Connection

@export_group("states")


@export_category("parameters")


func get_type() -> int:
	return 0

func get_inputs() -> Array[Modular_Connection]:
	return []

func get_outputs() -> Array[Modular_Connection]:
	return [frequency, active]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
