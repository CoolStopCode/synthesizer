class_name GraphArithmaticModule
extends GraphModule

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}


@export_category("inputs") 
@export var operand_a : GraphConnection
@export var operand_b : GraphConnection

@export_category("outputs")
@export var result : GraphConnection

@export_category("states")

@export_category("parameters")
@export var operation : Operation

func get_type() -> int:
	return 7

func get_inputs() -> Array[GraphConnection]:
	return [operand_a, operand_b]

func get_outputs() -> Array[GraphConnection]:
	return [result]

func get_states() -> Array[float]:
	return []

func get_parameters() -> Array[float]:
	return [float(operation)]
