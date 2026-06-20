class_name Node_BitcrusherModule
extends Node_Module

@export_category("inputs") 
@export var audio_in : Node_Connection

@export_category("outputs")
@export var audio_out : Node_Connection

@export_category("states")
@export var sample_hold_value : float
@export var phase : float

@export_category("parameters")
@export var bit_depth : int
@export var downsample_factor : float
@export var mix : float

func get_type() -> int:
	return 6

func get_inputs() -> Array[Node_Connection]:
	return [audio_in]

func get_outputs() -> Array[Node_Connection]:
	return [audio_out]

func get_states() -> Array[float]:
	return [sample_hold_value, phase]

func get_parameters() -> Array[float]:
	return [float(bit_depth), downsample_factor, mix]
