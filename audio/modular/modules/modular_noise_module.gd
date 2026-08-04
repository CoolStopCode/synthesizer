class_name ModularNoiseModule
extends ModularModule

enum Spectrum {
	WHITE,
	PINK,
	BROWN,
	VIOLET
}

@export_category("inputs") 

@export_category("outputs")
@export var sample : ModularConnection

@export_group("states")

@export_category("parameters")
@export var spectrum : Spectrum

func get_type() -> int:
	return 3

func get_inputs() -> Array[ModularConnection]:
	return []

func get_outputs() -> Array[ModularConnection]:
	return [sample]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(spectrum)]
