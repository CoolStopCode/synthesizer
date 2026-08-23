@abstract class_name ModularEditorModule
extends Control

signal port_up(port : ModularEditorPort)
signal port_down(port : ModularEditorPort)

@export var type_id : int
@export var ports : Array[ModularEditorPort]

@abstract func get_module_data() -> Array[float]
@abstract func get_input_map() -> Array[ModularEditorInputPort]
@abstract func get_output_map() -> Array[ModularEditorOutputPort]
