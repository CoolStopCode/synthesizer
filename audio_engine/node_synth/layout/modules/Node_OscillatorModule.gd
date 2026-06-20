class_name Node_OscillatorModule
extends Node_Module

enum Waveform {
	SINE,
	SQUARE,
	SAW,
	TRIANGLE
}


@export_category("inputs") 
@export var frequency : Node_Connection

@export_category("outputs")
@export var sample : Node_Connection

@export_category("states")
@export var phase : float

@export_category("parameters")
@export var waveform : Waveform

func get_type() -> int:
	return 2

func get_inputs() -> Array[Node_Connection]:
	return [frequency]

func get_outputs() -> Array[Node_Connection]:
	return [sample]

func get_states() -> Array[float]:
	return [phase]

func get_parameters() -> Array[float]:
	return [float(waveform)]
