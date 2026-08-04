class_name ModularAudioArithmaticModule
extends ModularAudioModule

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}


@export_category("inputs") 
@export var operand_a : ModularAudioConnection
@export var operand_b : ModularAudioConnection

@export_category("outputs")
@export var result : ModularAudioConnection

@export_group("states")

@export_category("parameters")
@export var operation : Operation

func get_type() -> int:
	return 7

func get_inputs() -> Array[ModularAudioConnection]:
	return [operand_a, operand_b]

func get_outputs() -> Array[ModularAudioConnection]:
	return [result]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(operation)]
