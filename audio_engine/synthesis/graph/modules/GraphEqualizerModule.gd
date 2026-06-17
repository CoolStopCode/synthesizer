class_name GraphEqualizerModule
extends GraphModule

enum FilterType {
	PEAK,
	LOW_SHELF,
	HIGH_SHELF,
	HPF,
	LPF
}

@export_category("inputs") 
@export var audio_in : GraphConnection

@export_category("outputs")
@export var audio_out : GraphConnection

@export_category("states")
@export var x1 : float
@export var x2 : float
@export var y1 : float
@export var y2 : float

@export_category("parameters")
@export var filter_type : FilterType
@export var frequency : float
@export var gain : float
@export var q_factor : float

func get_type() -> int:
	return 5

func get_inputs() -> Array[GraphConnection]:
	return [audio_in]

func get_outputs() -> Array[GraphConnection]:
	return [audio_out]

func get_states() -> Array[float]:
	return [x1, x2, y1, y2]

func get_parameters() -> Array[float]:
	return [float(filter_type), frequency, gain, q_factor]
