class_name ModularEditorLayout
extends Control

@export var modules_layer : ModularEditorModulesLayer
@export var connections_layer : ModularEditorConnectionsLayer

func _ready() -> void:
	modules_layer.create_new_module(preload("res://editor/modular/modules/arithmetic/modular_editor_arithmetic_module.tscn"))

func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton or event is InputEventScreenTouch): return
	
	var closest_port := modules_layer.closest_port_to(event.position)
	
	if event.is_pressed():
		if closest_port == null:
			return
		
		if not closest_port.in_click_radius(event.position):
			return
		
		if not closest_port.is_disconnected():
			connections_layer.lift_port(closest_port)
			return
		
		if not closest_port.can_create_connection:
			closest_port.clicked()
			return
		
		connections_layer.create_connection_from(closest_port)
	
	if not event.is_pressed():
		if closest_port == null:
			return
		
		if connections_layer.dragging_connection == null:
			return
		
		if not closest_port.in_click_radius(event.position):
			connections_layer.delete_dragging()
			return
			
		if not connections_layer.dragging_connection.can_connect_to(closest_port):
			connections_layer.delete_dragging()
			return
		
		connections_layer.connect_dragging(closest_port)

func get_module_parameter(module_index : int, parameter_index : int) -> ModularEditorParameter:
	return modules_layer.get_module_parameter(module_index, parameter_index)

func to_save() -> ModularEditorSave:
	var patch := ModularEditorSave.new()
	
	var module_indices    : Dictionary[ModularEditorParameter, int]
	var parameter_indices : Dictionary[ModularEditorParameter, int]
	for module_index in range(modules_layer.modules.size()):
		var module : ModularEditorModule = modules_layer.modules[module_index]
		for parameter_index in range(module.parameters.size()):
			module_indices[module.parameters[module_index]] = module_index
			parameter_indices[module.parameters[parameter_index]] = parameter_index
		
		patch.new_module_definition(
			module.id,
			module.position,
			module.get_parameter_values(),
			module.output_count
		)
	
	for connection in connections_layer.connections:
		var input_module_index     : int = module_indices[connection.input_port     as ModularEditorParameter]
		var input_parameter_index  : int = parameter_indices[connection.input_port  as ModularEditorParameter]
		var output_module_index    : int = module_indices[connection.output_port    as ModularEditorParameter]
		var output_parameter_index : int = parameter_indices[connection.output_port as ModularEditorParameter]
		patch.new_connection_definition(
			input_module_index,
			input_parameter_index,
			output_module_index,
			output_parameter_index
		)
	
	return patch
