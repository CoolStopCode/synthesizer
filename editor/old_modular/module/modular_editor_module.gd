@abstract class_name OldModularEdtiorModule
extends Control

signal port_up(port : OldModularEdtiorPort)
signal port_down(port : OldModularEdtiorPort)

@export var type_id : int
@export var ports : Array[OldModularEdtiorPort]

@abstract func get_module_data() -> Array[float]
@abstract func get_input_map() -> Array[OldModularEdtiorInputPort]
@abstract func get_output_map() -> Array[OldModularEdtiorOutputPort]
