class_name GraphEnvelopeModule
extends GraphModule

enum Stage {
	IDLE,
	ATTACK,
	DECAY,
	SUSTAIN,
	RELEASE
}

@export_category("inputs") 
@export var gate : GraphConnection

@export_category("outputs")
@export var level : GraphConnection

@export_category("states")
@export var current_level : float
@export var stage : Stage

@export_category("parameters")
@export var attack : float
@export var decay : float
@export var sustain : float
@export var release : float

func get_type() -> int:
	return 4

func get_inputs() -> Array[GraphConnection]:
	return [gate]

func get_outputs() -> Array[GraphConnection]:
	return [level]

func get_states() -> Array[float]:
	return [current_level, float(stage)]

func get_parameters() -> Array[float]:
	return [attack, decay, sustain, release]
