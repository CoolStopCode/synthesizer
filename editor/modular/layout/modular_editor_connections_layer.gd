class_name ModularEditorConnectionsLayer
extends Control

@export var connection_scene : PackedScene
@export var connections : Array[ModularEditorConnection]

func create_finished_connection(input : ModularEditorInputPort, output : ModularEditorOutputPort) -> ModularEditorConnection:
	var connection = create_connection()
	
	connection.connect_port(input)
	connection.connect_port(output)
	
	return connection

func create_dragging_connection(from : ModularEditorPort, finger_index : int) -> ModularEditorConnection:
	var connection = create_connection()
	
	connection.connect_port(from)
	connection.dragging = true
	connection.dragging_finger_index = finger_index
	
	return connection

func create_connection() -> ModularEditorConnection:
	var connection : ModularEditorConnection = connection_scene.instantiate()
	
	connections.append(connection)
	add_child(connection)
	
	return connection

func disconnect_port(port: ModularEditorPort, finger_index) -> void:
	var connection := connection_connected_to(port)
	if connection == null: return
	
	connection.disconnect_port(port)
	connection.dragging = true
	connection.dragging_finger_index = finger_index

func connection_connected_to(port: ModularEditorPort) -> ModularEditorConnection:
	for connection in connections:
		if connection.input_port  == port: return connection
		if connection.output_port == port: return connection
	return null

func delete_connection(connection : ModularEditorConnection) -> void:
	connections.erase(connection)
	if connection.input_port:
		connection.input_port .disconnected.emit()
		connection.input_port .connection = null
	if connection.output_port:
		connection.output_port.disconnected.emit()
		connection.output_port.connection = null
	
	connection.queue_free()

func connection_from_finger_index(finger_index : int) -> ModularEditorConnection:
	for connection in connections:
		if not connection.dragging: continue
		
		if connection.dragging_finger_index == finger_index:
			return connection
	
	return null

func get_connection_definitions(
	input_map : Dictionary[ModularEditorInputPort , Vector2i],
	output_map: Dictionary[ModularEditorOutputPort, Vector2i]
) -> Array[ModularEditorConnectionDefinition]:
	var connection_definitions : Array[ModularEditorConnectionDefinition]
	
	for connection in connections:
		var input_location  : Vector2i = input_map [connection.input_port ]
		var output_location : Vector2i = output_map[connection.output_port]
		var connection_definition := ModularEditorConnectionDefinition.new()
		connection_definition.input_module_index     = input_location .x
		connection_definition.input_parameter_index  = input_location .y
		connection_definition.output_module_index    = output_location.x
		connection_definition.output_output_index    = output_location.y
		connection_definitions.append(connection_definition)
	
	return connection_definitions
