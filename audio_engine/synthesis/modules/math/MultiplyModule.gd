class_name MultiplyModule
extends Module

@export_category("PORTS")
@export var argument1_in: FloatPort
@export var argument2_in: FloatPort
@export var output_out: FloatPort

func _init():
	inputs = [
		argument1_in,
		argument2_in
	]
	outputs = [
		output_out
	]

func process(delta : float) -> void:
	var output : float = argument1_in.value * argument2_in.value
	
	output_out.value = output
