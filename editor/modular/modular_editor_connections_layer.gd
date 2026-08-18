class_name ModularEditorConnectionsLayer
extends Control

@export var connection_scene : PackedScene
@export var connections : Array[ModularEditorConnection]

func create_connection(from : ModularEditorPort) -> ModularEditorConnection:
	var connection_instance : ModularEditorConnection = connection_scene.instantiate()
	
	connections.append(connection_instance)
	add_child(connection_instance)
	
	connection_instance.connect_to_port(from)
	
	return connection_instance
