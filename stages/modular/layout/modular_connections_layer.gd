class_name ModularConnectionsLayer
extends Control

@export var connection_scene : PackedScene
@export var connections : Array[ModularConnection]

func create_finished_connection(input : ModularInputPort, output : ModularOutputPort) -> ModularConnection:
	var connection = create_connection()
	
	connection.connect_port(input)
	connection.connect_port(output)
	
	return connection

func create_dragging_connection(from : ModularPort, finger_index : int) -> ModularConnection:
	var connection = create_connection()
	
	connection.connect_port(from)
	connection.dragging = true
	connection.dragging_finger_index = finger_index
	
	return connection

func create_connection() -> ModularConnection:
	var connection : ModularConnection = connection_scene.instantiate()
	
	connections.append(connection)
	add_child(connection)
	
	return connection

func disconnect_port(port: ModularPort, finger_index) -> void:
	var connection := connection_connected_to(port)
	if connection == null: return
	
	connection.disconnect_port(port)
	connection.dragging = true
	connection.dragging_finger_index = finger_index

func connection_connected_to(port: ModularPort) -> ModularConnection:
	for connection in connections:
		if connection.input_port  == port: return connection
		if connection.output_port == port: return connection
	return null

func delete_connection(connection : ModularConnection) -> void:
	connections.erase(connection)
	if connection.input_port:
		connection.input_port .disconnected.emit()
		connection.input_port .connection = null
	if connection.output_port:
		connection.output_port.disconnected.emit()
		connection.output_port.connection = null
	
	connection.queue_free()

func connection_from_finger_index(finger_index : int) -> ModularConnection:
	for connection in connections:
		if not connection.dragging: continue
		
		if connection.dragging_finger_index == finger_index:
			return connection
	
	return null

func get_connection_definitions(
	input_map : Dictionary[ModularInputPort , Vector2i],
	output_map: Dictionary[ModularOutputPort, Vector2i]
) -> Array[ModularConnectionDefinition]:
	var connection_definitions : Array[ModularConnectionDefinition]
	
	for connection in connections:
		var input_location  : Vector2i = input_map [connection.input_port ]
		var output_location : Vector2i = output_map[connection.output_port]
		var connection_definition := ModularConnectionDefinition.new()
		connection_definition.input_module_index     = input_location .x
		connection_definition.input_parameter_index  = input_location .y
		connection_definition.output_module_index    = output_location.x
		connection_definition.output_output_index    = output_location.y
		connection_definitions.append(connection_definition)
	
	return connection_definitions
