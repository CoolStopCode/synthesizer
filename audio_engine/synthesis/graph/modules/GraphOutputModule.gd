class_name GraphOutputModule
extends GraphModule

@export_category("inputs") 
@export var sample : GraphConnection

@export_category("outputs")

@export_category("states")

@export_category("parameters")


func get_type() -> int:
	return 1

func get_inputs() -> Array[GraphConnection]:
	return [sample]

func get_outputs() -> Array[GraphConnection]:
	return []

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
