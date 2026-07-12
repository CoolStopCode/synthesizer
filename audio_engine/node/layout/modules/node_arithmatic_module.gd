class_name Node_ArithmaticModule
extends Node_Module

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}


@export_category("inputs") 
@export var operand_a : Node_Connection
@export var operand_b : Node_Connection

@export_category("outputs")
@export var result : Node_Connection

@export_group("states")

@export_category("parameters")
@export var operation : Operation

func get_type() -> int:
	return 7

func get_inputs() -> Array[Node_Connection]:
	return [operand_a, operand_b]

func get_outputs() -> Array[Node_Connection]:
	return [result]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(operation)]
