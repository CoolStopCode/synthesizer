class_name OldModularEdtiorOutputModule
extends OldModularEdtiorModule

@export var sample_port : OldModularEdtiorInputPort

func get_module_data() -> Array[float]:
	return [
		sample_port.get_value()
	]

func get_input_map() -> Array[OldModularEdtiorInputPort]:
	return [
		sample_port
	]

func get_output_map() -> Array[OldModularEdtiorOutputPort]:
	return [
		
	]
