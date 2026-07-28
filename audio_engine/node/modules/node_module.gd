@abstract class_name Node_Module
extends Resource

@abstract func get_type() -> int

@abstract func get_inputs() -> Array[Node_Connection]

@abstract func get_outputs() -> Array[Node_Connection]

@abstract func get_states() -> Array[float]

@abstract func get_parameters() -> Array[float]
