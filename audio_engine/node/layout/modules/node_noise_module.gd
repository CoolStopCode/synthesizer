class_name Node_NoiseModule
extends Node_Module

enum Spectrum {
	WHITE,
	PINK,
	BROWN,
	VIOLET
}

@export_category("inputs") 

@export_category("outputs")
@export var sample : Node_Connection

@export_group("states")

@export_category("parameters")
@export var spectrum : Spectrum

func get_type() -> int:
	return 3

func get_inputs() -> Array[Node_Connection]:
	return []

func get_outputs() -> Array[Node_Connection]:
	return [sample]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(spectrum)]
