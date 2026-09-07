class_name OldModularEdtiorEnvelopeModule
extends OldModularEdtiorModule

@export var gate_port : OldModularEdtiorInputPort
@export var a_port : OldModularEdtiorDialPort
@export var d_port : OldModularEdtiorDialPort
@export var s_port : OldModularEdtiorDialPort
@export var r_port : OldModularEdtiorDialPort
@export var output_port : OldModularEdtiorOutputPort

func get_module_data() -> Array[float]:
	return [
		gate_port.get_value(),
		0.0, 0.0, 0.0, 0.0, 0.0,
		a_port.get_value(),
		d_port.get_value(),
		s_port.get_value(),
		r_port.get_value(),
		0.5,
		0.5,
		0.5,
		false
	]

func get_input_map() -> Array[OldModularEdtiorInputPort]:
	return [
		gate_port,
		null, null, null, null, null,
		a_port,
		d_port,
		s_port,
		r_port,
		null, null, null, null
	]

func get_output_map() -> Array[OldModularEdtiorOutputPort]:
	return [
		output_port
	]
