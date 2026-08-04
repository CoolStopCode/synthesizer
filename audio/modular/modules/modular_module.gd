@abstract class_name ModularModule
extends Resource

@abstract func get_type() -> int

@abstract func get_inputs() -> Array[ModularConnection]

@abstract func get_outputs() -> Array[ModularConnection]

@abstract func get_states() -> Array[float]

@abstract func get_parameters() -> Array[float]
