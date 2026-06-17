class_name GraphModule
extends Resource

func get_type() -> int:
	return 0

func get_inputs() -> Array[GraphConnection]:
	return []

func get_outputs() -> Array[GraphConnection]:
	return []

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return []
