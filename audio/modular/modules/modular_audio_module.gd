@abstract class_name ModularAudioModule
extends Resource

@abstract func get_type() -> int

@abstract func get_inputs() -> Array[ModularAudioConnection]

@abstract func get_outputs() -> Array[ModularAudioConnection]

@abstract func get_states() -> Array[float]

@abstract func get_parameters() -> Array[float]
