class_name ModularArithmaticModule
extends ModularModule

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}


@export_category("inputs") 
@export var operand_a : ModularConnection
@export var operand_b : ModularConnection

@export_category("outputs")
@export var result : ModularConnection

@export_group("states")

@export_category("parameters")
@export var operation : Operation

func get_type() -> int:
	return 7

func get_inputs() -> Array[ModularConnection]:
	return [operand_a, operand_b]

func get_outputs() -> Array[ModularConnection]:
	return [result]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(operation)]
