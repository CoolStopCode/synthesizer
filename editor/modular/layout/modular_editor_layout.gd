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
	var save := ModularEditorSave.new()
	
	var parameter_map := modules_layer.get_parameter_map()
	var module_definitions := modules_layer.get_module_definitions()
	var connection_definitions := connections_layer.get_connection_definitions(parameter_map)
	
	save.module_definitions = module_definitions
	save.connection_definitions = connection_definitions
	
	return save

func to_audio_layout() -> ModularAudioLayout:
	var parameter_map := modules_layer.get_parameter_map()
	var module_definitions := modules_layer.get_module_definitions()
	var connection_definitions := connections_layer.get_connection_definitions(parameter_map)
	
	var layout := ModularAudioLayout.new()
	
	var types : PackedByteArray
	var module_offsets : PackedInt32Array
	var output_offsets : PackedInt32Array
	
	var output_routes : PackedInt32Array
	var memory_data : PackedFloat64Array = PackedFloat64Array([0.0, 0.0, 0.0, 0.0])
	
	for module_definition in module_definitions:
		types.append(module_definition.id)
		module_offsets.append(memory_data.size())
		memory_data.append_array(module_definition.parameter_values)
	
	var total_outputs := 0
	for module_definition in module_definitions:
		output_offsets.append(total_outputs)
		total_outputs += module_definition.output_count
	
	output_routes.resize(total_outputs)
	for connection_definition in connection_definitions:
		var output_route_index : int      = output_offsets[connection_definition.output_module_index] + connection_definition.output_parameter_index
		output_routes[output_route_index] = module_offsets[connection_definition.input_module_index ] + connection_definition.input_parameter_index
	
	layout.types = types
	layout.module_offsets = module_offsets
	layout.output_offsets = output_offsets
	layout.output_routes = output_routes
	layout.memory_data = memory_data
	
	return layout
