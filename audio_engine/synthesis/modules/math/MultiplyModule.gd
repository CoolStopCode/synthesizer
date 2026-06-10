class_name GDMultiplyModule
extends GDModule

@export_category("PORTS")
@export var IN_argument1: GDFloatPort
@export var IN_argument2: GDFloatPort
@export var OUT_output: GDFloatPort

func _init():
	inputs = [
		IN_argument1,
		IN_argument2
	]
	outputs = [
		OUT_output
	]

func process(delta : float) -> void:
	var output : float = IN_argument1.value * IN_argument2.value

	OUT_output.value = output
