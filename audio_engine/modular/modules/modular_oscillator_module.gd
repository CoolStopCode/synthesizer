class_name Modular_OscillatorModule
extends Modular_Module

enum Waveform {
	SINE,
	SQUARE,
	SAW,
	TRIANGLE
}


@export_category("inputs") 
@export var frequency : Modular_Connection

@export_category("outputs")
@export var sample : Modular_Connection

@export_group("states")
@export var phase : float

@export_category("parameters")
@export var waveform : Waveform

func get_type() -> int:
	return 2

func get_inputs() -> Array[Modular_Connection]:
	return [frequency]

func get_outputs() -> Array[Modular_Connection]:
	return [sample]

func get_states() -> Array[float]:
	return [phase]

func get_parameters() -> Array[float]:
	return [float(waveform)]
