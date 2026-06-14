class_name InputModule
extends Module

@export_category("SETTINGS")
@export var active : bool
@export var frequency : float

@export_category("PORTS")
@export var OUT_active : BoolPort
@export var OUT_frequency : FloatPort

func _init() -> void:
	inputs = []
	outputs = [
		OUT_active,
		OUT_frequency
	]

func process(delta : float):
	OUT_active.value = active
	OUT_frequency.value = frequency
