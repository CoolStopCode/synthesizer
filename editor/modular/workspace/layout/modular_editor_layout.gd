class_name ModularEditorLayout
extends Control

@export var modules_layer : ModularEditorModulesLayer
@export var connections_layer : ModularEditorConnectionsLayer

func _input(event: InputEvent) -> void:
	if not event is InputEventScreenTouch: return
	
	var closest_port := modules_layer.closest_port_to(event.position)
	
	if event.is_pressed():
		if closest_port == null:
			return
		
		if not closest_port.in_click_radius(event.position):
			return
		
		if closest_port.has_connected():
			closest_port.connection.dragging = true
			closest_port.connection.disconnect_port(closest_port)
			return
		
		if not closest_port.can_create_connection:
			closest_port.pressed.emit(event)
			return
		
		connections_layer.create_dragging_connection(closest_port, event.index)
	
	if not event.is_pressed():
		if closest_port == null:
			return
		
		var released_connection := connections_layer.connection_from_finger_index(event.index)
		
		if released_connection == null:
			return
		
		if not closest_port.in_click_radius(event.position):
			connections_layer.delete_connection(released_connection)
			return
			
		if not released_connection.can_connect_to(closest_port):
			connections_layer.delete_connection(released_connection)
			return
		
		released_connection.dragging = false
		released_connection.connect_port(closest_port)

func to_save() -> ModularEditorSave:
	var save := ModularEditorSave.new()
	
	var module_definitions := modules_layer.get_module_definitions()
	var connection_definitions := connections_layer.get_connection_definitions(
		modules_layer.get_input_map(),
		modules_layer.get_output_map()
	)
	
	save.module_definitions = module_definitions
	save.connection_definitions = connection_definitions
	
	return save

func to_audio_layout() -> ModularAudioLayout:
	var layout := ModularAudioLayout.new()
	
	var module_definitions := modules_layer.get_module_definitions()
	var connection_definitions := connections_layer.get_connection_definitions(
		modules_layer.get_input_map(),
		modules_layer.get_output_map()
	)
	
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
		var output_route_index : int      = output_offsets[connection_definition.output_module_index] + connection_definition.output_output_index
		output_routes[output_route_index] = module_offsets[connection_definition.input_module_index ] + connection_definition.input_parameter_index
	
	layout.types = types
	layout.module_offsets = module_offsets
	layout.output_offsets = output_offsets
	layout.output_routes = output_routes
	layout.memory_data = memory_data
	
	return layout
