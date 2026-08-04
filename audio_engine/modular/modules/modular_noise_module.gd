class_name Modular_NoiseModule
extends Modular_Module

enum Spectrum {
	WHITE,
	PINK,
	BROWN,
	VIOLET
}

@export_category("inputs") 

@export_category("outputs")
@export var sample : Modular_Connection

@export_group("states")

@export_category("parameters")
@export var spectrum : Spectrum

func get_type() -> int:
	return 3

func get_inputs() -> Array[Modular_Connection]:
	return []

func get_outputs() -> Array[Modular_Connection]:
	return [sample]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(spectrum)]
