class_name Modular_ArithmaticModule
extends Modular_Module

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}


@export_category("inputs") 
@export var operand_a : Modular_Connection
@export var operand_b : Modular_Connection

@export_category("outputs")
@export var result : Modular_Connection

@export_group("states")

@export_category("parameters")
@export var operation : Operation

func get_type() -> int:
	return 7

func get_inputs() -> Array[Modular_Connection]:
	return [operand_a, operand_b]

func get_outputs() -> Array[Modular_Connection]:
	return [result]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(operation)]
