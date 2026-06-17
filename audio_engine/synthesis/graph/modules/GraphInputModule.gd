class_name GraphInputModule
extends GraphModule

@export_category("inputs") 


@export_category("outputs")
@export var frequency : GraphConnection
@export var active : GraphConnection

@export_category("states")


@export_category("parameters")


func get_type() -> int:
	return 0

func get_inputs() -> Array[GraphConnection]:
	return []

func get_outputs() -> Array[GraphConnection]:
	return [frequency, active]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
