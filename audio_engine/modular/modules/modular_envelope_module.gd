class_name Modular_EnvelopeModule
extends Modular_Module

enum Stage {
	IDLE,
	ATTACK,
	DECAY,
	SUSTAIN,
	RELEASE
}

@export_category("inputs")
@export var gate : Modular_Connection

@export_category("outputs")
@export var level : Modular_Connection

@export_group("states")
@export var current_level : float
@export var stage : Stage
@export var phase : float
@export var attack_start_level : float
@export var release_start_level : float

@export_category("parameters")
@export var attack : float
@export var decay : float
@export var sustain : float
@export var release : float
@export var attack_curve : float
@export var decay_curve : float
@export var release_curve : float
@export var reset : bool

func get_type() -> int:
	return 4

func get_inputs() -> Array[Modular_Connection]:
	return [gate]

func get_outputs() -> Array[Modular_Connection]:
	return [level]

func get_states() -> Array[float]:
	return [current_level, float(stage), phase, attack_start_level, release_start_level]

func get_parameters() -> Array[float]:
	return [attack, decay, sustain, release, attack_curve, decay_curve, release_curve, float(reset)]
