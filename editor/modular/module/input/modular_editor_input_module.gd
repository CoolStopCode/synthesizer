class_name ModularEditorInputModule
extends ModularEditorModule

@export var frequency_port : ModularEditorOutputPort
@export var pressed_port : ModularEditorOutputPort

func get_module_data() -> Array[float]:
	return [
	
	]

func get_input_map() -> Array[ModularEditorInputPort]:
	return [
	
	]

func get_output_map() -> Array[ModularEditorOutputPort]:
	return [
		frequency_port,
		pressed_port
	]
