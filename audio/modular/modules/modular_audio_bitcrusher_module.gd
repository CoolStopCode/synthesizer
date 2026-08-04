class_name ModularAudioBitcrusherModule
extends ModularAudioModule

@export_category("inputs") 
@export var audio_in : ModularAudioConnection

@export_category("outputs")
@export var audio_out : ModularAudioConnection

@export_group("states")
@export var sample_hold_value : float
@export var phase : float

@export_category("parameters")
@export var bit_depth : int
@export var downsample_factor : float
@export var mix : float

func get_type() -> int:
	return 6

func get_inputs() -> Array[ModularAudioConnection]:
	return [audio_in]

func get_outputs() -> Array[ModularAudioConnection]:
	return [audio_out]

func get_states() -> Array[float]:
	return [sample_hold_value, phase]

func get_parameters() -> Array[float]:
	return [float(bit_depth), downsample_factor, mix]
