class_name ModularAudioFilterModule
extends ModularAudioModule

enum FilterMode {
	LOWPASS,
	BANDPASS,
	HIGHPASS
}

@export_category("inputs") 
@export var audio_in : ModularAudioConnection

@export_category("outputs")
@export var audio_out : ModularAudioConnection

@export_group("states")
@export var lowpass : float
@export var bandpass : float


@export_category("parameters")
@export var cutoff : float
@export var resonance: float
@export var filter_mode: FilterMode

func get_type() -> int:
	return 5

func get_inputs() -> Array[ModularAudioConnection]:
	return [audio_in]

func get_outputs() -> Array[ModularAudioConnection]:
	return [audio_out]

func get_states() -> Array[float]:
	return [lowpass, bandpass]

func get_parameters() -> Array[float]:
	return [cutoff, resonance, float(filter_mode)]
