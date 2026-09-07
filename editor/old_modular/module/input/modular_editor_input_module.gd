class_name OldModularEdtiorInputModule
extends OldModularEdtiorModule

@export var frequency_port : OldModularEdtiorOutputPort
@export var pressed_port : OldModularEdtiorOutputPort

func get_module_data() -> Array[float]:
	return [
	
	]

func get_input_map() -> Array[OldModularEdtiorInputPort]:
	return [
	
	]

func get_output_map() -> Array[OldModularEdtiorOutputPort]:
	return [
		frequency_port,
		pressed_port
	]
