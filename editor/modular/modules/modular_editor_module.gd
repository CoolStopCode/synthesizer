@abstract class_name ModularEditorModule
extends Control

@export var id : int
@export var parameters : Array[ModularEditorParameter]
@export var output_count : int

func get_parameter_values() -> Array[float]:
	var parameter_values : Array[float]
	
	for parameter in parameters:
		if parameter == null:
			parameter_values.append(0.0)
		else:
			parameter_values.append(parameter.get_value())
	
	return parameter_values
