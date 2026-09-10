class_name ModularEditorConnectionsLayer
extends Control

@export var connection_scene : PackedScene
@export var connections : Array[ModularEditorConnection]
@export var dragging_connection : ModularEditorConnection

func create_connection_at(input : ModularEditorInputPort, output : ModularEditorOutputPort) -> ModularEditorConnection:
	var connection = create_connection()
	connection.connect_input_output(input, output)
	return connection

func create_new_connection(from : ModularEditorPort) -> ModularEditorConnection:
	var connection = create_connection()
	connection.connect_to(from)
	dragging_connection = connection
	return connection

func create_connection() -> ModularEditorConnection:
	var connection : ModularEditorConnection = connection_scene.instantiate()
	
	connections.append(connection)
	add_child(connection)
	
	return connection

func connect_dragging(port: ModularEditorPort) -> void:
	dragging_connection.connect_to(port)
	dragging_connection = null

func delete_dragging() -> void:
	delete_connection(dragging_connection)

func lift_port(port: ModularEditorPort) -> void:
	var connection = connection_connected_to(port)
	if connection == null: return
	
	dragging_connection = connection
	dragging_connection.lift_port(port)

func connection_connected_to(port: ModularEditorPort) -> ModularEditorConnection:
	for connection in connections:
		if connection.input_port  == port: return connection
		if connection.output_port == port: return connection
	return null

func delete_connection(connection : ModularEditorConnection) -> void:
	connections.erase(connection)
	connection.queue_free()

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
