class_name GDInputModule
extends GDModule

@export_category("SETTINGS")
@export var active : bool
@export var frequency : float

@export_category("PORTS")
@export var OUT_active : GDBoolPort
@export var OUT_frequency : GDFloatPort

func _init() -> void:
	inputs = []
	outputs = [
		OUT_active,
		OUT_frequency
	]

func process(delta : float):
	OUT_active.value = active
	OUT_frequency.value = frequency
