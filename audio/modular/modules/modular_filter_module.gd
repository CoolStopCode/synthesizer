class_name ModularFilterModule
extends ModularModule

enum FilterMode {
	LOWPASS,
	BANDPASS,
	HIGHPASS
}

@export_category("inputs") 
@export var audio_in : ModularConnection

@export_category("outputs")
@export var audio_out : ModularConnection

@export_group("states")
@export var lowpass : float
@export var bandpass : float


@export_category("parameters")
@export var cutoff : float
@export var resonance: float
@export var filter_mode: FilterMode

func get_type() -> int:
	return 5

func get_inputs() -> Array[ModularConnection]:
	return [audio_in]

func get_outputs() -> Array[ModularConnection]:
	return [audio_out]

func get_states() -> Array[float]:
	return [lowpass, bandpass]

func get_parameters() -> Array[float]:
	return [cutoff, resonance, float(filter_mode)]
