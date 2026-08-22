class_name ModularEditorEnvelopeModule
extends ModularEditorModule

@export var gate_port : ModularEditorInputPort
@export var a_port : ModularEditorDialPort
@export var d_port : ModularEditorDialPort
@export var s_port : ModularEditorDialPort
@export var r_port : ModularEditorDialPort
@export var output_port : ModularEditorOutputPort

func get_module_data() -> Array[float]:
	return [
		gate_port.get_value(),
		0.0, 0.0, 0.0, 0.0, 0.0,
		a_port.get_value(),
		d_port.get_value(),
		s_port.get_value(),
		r_port.get_value(),
		1.0,
		1.0,
		1.0,
		true
	]

func get_input_map() -> Array[ModularEditorInputPort]:
	return [
		gate_port,
		null, null, null, null, null,
		a_port,
		d_port,
		s_port,
		r_port,
		null, null, null, null
	]

func get_output_map() -> Array[ModularEditorOutputPort]:
	return [
		output_port
	]
