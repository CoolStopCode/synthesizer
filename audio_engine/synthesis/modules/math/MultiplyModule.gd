class_name MultiplyModule
extends Module

@export_category("PORTS")
@export var IN_argument1: FloatPort
@export var IN_argument2: FloatPort
@export var OUT_output: FloatPort

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
