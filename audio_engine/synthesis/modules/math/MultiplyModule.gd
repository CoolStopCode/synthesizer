class_name MultiplyModule
extends Module

@export_category("PORTS")
@export var argument1_in: FloatPortIn
@export var argument2_in: FloatPortIn
@export var output_out: FloatPortOut

func _init():
	inputs = [
		argument1_in,
		argument2_in
	]
	outputs = [
		output_out
	]

func process(delta : float) -> void:
	var output : float = argument1_in.get_value() * argument2_in.get_value()

	output_out.value = output
