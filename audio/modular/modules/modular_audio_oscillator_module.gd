class_name ModularAudioOscillatorModule
extends ModularAudioModule

enum Waveform {
	SINE,
	SQUARE,
	SAW,
	TRIANGLE
}


@export_category("inputs") 
@export var frequency : ModularAudioConnection

@export_category("outputs")
@export var sample : ModularAudioConnection

@export_group("states")
@export var phase : float

@export_category("parameters")
@export var waveform : Waveform

func get_type() -> int:
	return 2

func get_inputs() -> Array[ModularAudioConnection]:
	return [frequency]

func get_outputs() -> Array[ModularAudioConnection]:
	return [sample]

func get_states() -> Array[float]:
	return [phase]

func get_parameters() -> Array[float]:
	return [float(waveform)]
