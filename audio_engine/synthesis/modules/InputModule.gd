class_name InputModule
extends Module

@export_category("SETTINGS")
@export var active : bool
@export var frequency : float

@export_category("PORTS")
@export var active_out : BoolPortOut
@export var frequency_out : FloatPortOut

func _init() -> void:
	inputs = []
	outputs = [
		active_out,
		frequency_out
	]

func process(delta : float):
	active_out.value = active
	frequency_out.value = frequency
