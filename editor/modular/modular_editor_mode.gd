class_name ModularEditorMode
extends EditorMode

@export var modules_layer : ModularEditorModulesLayer
@export var connections_layer : ModularEditorConnectionsLayer

@export var input_module_scene : PackedScene
@export var output_module_scene : PackedScene

var dragging_connection : ModularEditorConnection

func _ready() -> void:
	var input := modules_layer.create_module(input_module_scene)
	var output := modules_layer.create_module(output_module_scene)
	input.position = Vector2(0, 0)
	output.position = Vector2(0, 44)
	modules_layer.create_module(preload("res://editor/modular/modules/envelope/modular_editor_envelope.tscn"))
	modules_layer.create_module(preload("res://editor/modular/modules/envelope/modular_editor_envelope.tscn"))
	modules_layer.create_module(preload("res://editor/modular/modules/envelope/modular_editor_envelope.tscn"))

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton and not event is InputEventScreenTouch:
		return

	var closest_port := modules_layer.closest_port_to(event.global_position)

	if event.is_pressed():
		if closest_port.in_click_area(event.global_position):
			port_clicked(closest_port)
	else:
		if dragging_connection != null:
			release_connection(closest_port, event.global_position)

func release_connection(port: ModularEditorPort, event_position : Vector2) -> void:
	modules_layer.highlight_off()
	
	if (not port.in_click_area(event_position))\
	or (not dragging_connection.can_connect_to(port)):
		dragging_connection.queue_free()
		return

	dragging_connection.connect_to_port(port)

func port_clicked(port: ModularEditorPort) -> void:
	if port.is_empty():
		modules_layer.highlight_on(port)
		dragging_connection = connections_layer.create_connection(port)
	else:
		var connection := port.connection
		dragging_connection = connection
		connection.lift_port(port)
		modules_layer.highlight_on(connection.get_connected_port())

#func build_voice() -> ModularAudioVoice: # TODO: Redo this
	#var voice := ModularAudioVoice.new()
	#
	#var types : PackedByteArray
	#
	#var input_offsets : PackedInt32Array
	#var output_offsets : PackedInt32Array
	#var state_offsets : PackedInt32Array
	#var parameter_offsets : PackedInt32Array
	#
	#var input_routes : PackedInt32Array 
	#var initial_memory_data : PackedFloat64Array
	#initial_memory_data.append_array([0.0, 0.0, 0.0, 0.0])
	#
	#for module in modules:
		#var type := module.type_id
		#
		#var module_states := module.states
		#var module_parameters := module.parameters
		#
		#types.append(type)
		#
		#var state_data: Array[float] = module.get_states()
		#state_offsets.append(initial_memory_data.size())
		#initial_memory_data.append_array(state_data)
		#
		#var parameter_data: Array[float] = module.get_parameters()
		#parameter_offsets.append(initial_memory_data.size())
		#initial_memory_data.append_array(parameter_data)
	#
	#var connection_map : Dictionary[ModularEditorPort, ModularEditorPort]
	#for connection in connections:
		#if connection.from.is_input_port():
			#connection_map[connection.from] = connection.to
		#elif connection.from.is_output_port():
			#connection_map[connection.to] = connection.from
	#
	#var output_index_map : Dictionary[ModularEditorPort, int]
	#for module in modules:
		#var output_ports : Array[ModularEditorPort]
		#for port in module.ports:
			#if port.is_output_port():
				#output_ports.append(port)
		#
		#for i in range(output_ports.size()):
			#var output_port := output_ports[i]
			#output_index_map[output_port] = initial_memory_data.size() + i
		#
		#var output_data: Array[float]
		#output_data.resize(output_ports.size())
		#output_offsets.append(initial_memory_data.size())
		#initial_memory_data.append_array(output_data)
	#
	#for module in modules:
		#var input_ports : Array[ModularEditorPort]
		#for port in module.ports:
			#if port.is_input_port():
				#input_ports.append(port)
		#
		#input_offsets.append(input_routes.size())
		#
		#for input_port in input_ports:
			#input_routes.append(output_index_map[connection_map[input_port]])
	#
	#voice.set_layout(
		#types,
		#input_offsets,
		#output_offsets,
		#state_offsets,
		#parameter_offsets,
		#input_routes,
		#initial_memory_data
	#)
	#
	#return voice
