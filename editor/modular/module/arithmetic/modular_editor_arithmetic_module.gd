class_name ModularEditorArithmeticModule
extends ModularEditorModule

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

@export var operation : Operation
@export var operation_button : InterfaceButton
@export var operand_a_port : ModularEditorInputPort
@export var operand_b_port : ModularEditorInputPort
@export var result_port : ModularEditorOutputPort
@export var operation_textures : Dictionary[Operation, Texture]

func get_module_data() -> Array[float]:
	return [
		operand_a_port.get_value(),
		operand_b_port.get_value(),
		operation
	]

func get_input_map() -> Array[ModularEditorInputPort]:
	return [
		operand_a_port,
		operand_b_port,
		null
	]

func get_output_map() -> Array[ModularEditorOutputPort]:
	return [
		result_port
	]

func _ready() -> void:
	operation_button.icon = operation_textures[operation]
	operation_button.update_visuals()

func _on_operation_button_pressed() -> void:
	operation = (operation + 1) % Operation.size() as Operation
	
	operation_button.icon = operation_textures[operation]
	operation_button.update_visuals()
