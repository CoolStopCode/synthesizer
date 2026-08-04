class_name Modular_ConstantModule
extends Modular_Module

@export_category("inputs") 

@export_category("outputs")
@export var output : Modular_Connection

@export_group("states")

@export_category("parameters")
@export var value : float

func get_type() -> int:
	return -1

func get_inputs() -> Array[Modular_Connection]:
	return []

func get_outputs() -> Array[Modular_Connection]:
	return [output]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [value]
