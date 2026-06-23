class_name Node_FilterModule
extends Node_Module

enum FilterMode {
	LOWPASS,
	BANDPASS,
	HIGHPASS
}

@export_category("inputs") 
@export var audio_in : Node_Connection

@export_category("outputs")
@export var audio_out : Node_Connection

@export_category("states")
@export var lowpass : float
@export var bandpass : float


@export_category("parameters")
@export var cutoff : float
@export var resonance: float
@export var filter_mode: FilterMode

func get_type() -> int:
	return 5

func get_inputs() -> Array[Node_Connection]:
	return [audio_in]

func get_outputs() -> Array[Node_Connection]:
	return [audio_out]

func get_states() -> Array[float]:
	return [lowpass, bandpass]

func get_parameters() -> Array[float]:
	return [cutoff, resonance, float(filter_mode)]
