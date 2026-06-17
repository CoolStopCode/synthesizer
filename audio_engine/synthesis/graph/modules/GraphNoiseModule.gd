class_name GraphNoiseModule
extends GraphModule

enum Spectrum {
	WHITE,
	PINK,
	BROWN,
	VIOLET
}

@export_category("inputs") 

@export_category("outputs")
@export var sample : GraphConnection

@export_category("states")

@export_category("parameters")
@export var spectrum : Spectrum

func get_type() -> int:
	return 3

func get_inputs() -> Array[GraphConnection]:
	return []

func get_outputs() -> Array[GraphConnection]:
	return [sample]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(spectrum)]
