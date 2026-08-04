@abstract class_name Modular_Module
extends Resource

@abstract func get_type() -> int

@abstract func get_inputs() -> Array[Modular_Connection]

@abstract func get_outputs() -> Array[Modular_Connection]

@abstract func get_states() -> Array[float]

@abstract func get_parameters() -> Array[float]
