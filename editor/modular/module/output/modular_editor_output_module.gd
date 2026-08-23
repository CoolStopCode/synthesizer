class_name ModularEditorOutputModule
extends ModularEditorModule

@export var sample_port : ModularEditorInputPort

func get_module_data() -> Array[float]:
	return [
		sample_port.get_value()
	]

func get_input_map() -> Array[ModularEditorInputPort]:
	return [
		sample_port
	]

func get_output_map() -> Array[ModularEditorOutputPort]:
	return [
		
	]
