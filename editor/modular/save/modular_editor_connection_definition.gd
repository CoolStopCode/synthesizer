class_name ModularEditorConnectionDefinition
extends Resource

@export var input_module_index : int
@export var input_parameter_index : int
@export var output_module_index : int
@export var output_parameter_index : int

func _init(
	_input_module_index : int,
	_input_parameter_index : int,
	_output_module_index : int,
	_output_parameter_index : int
) -> void:
	input_module_index     = _input_module_index
	input_parameter_index  = _input_parameter_index
	output_module_index    = _output_module_index
	output_parameter_index = _output_parameter_index
