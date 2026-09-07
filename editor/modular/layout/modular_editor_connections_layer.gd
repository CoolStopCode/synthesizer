class_name ModularEditorConnectionsLayer
extends Control

@export var connection_scene : PackedScene
@export var connections : Array[ModularEditorConnection]
@export var dragging_connection : ModularEditorConnection

func create_connection_from(port : ModularEditorPort) -> ModularEditorConnection:
	var connection = create_connection()
	connection.connect_to(port)
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
