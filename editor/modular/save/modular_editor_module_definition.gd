class_name ModularEditorModuleDefinition
extends Resource

@export var id : int
@export var position : Vector2
@export var parameter_values : Array[float]
@export var output_count : int

func _init(
	_id : int,
	_position : Vector2,
	_parameter_values : Array[float],
	_output_count : int
) -> void:
	id               = _id
	position         = _position
	parameter_values = _parameter_values
	output_count     = _output_count
