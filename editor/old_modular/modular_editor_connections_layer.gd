class_name OldModularEdtiorConnectionsLayer
extends Control

@export var connection_scene : PackedScene
@export var connections : Array[OldModularEdtiorConnection]

func create_connection(from : OldModularEdtiorPort) -> OldModularEdtiorConnection:
	var connection_instance : OldModularEdtiorConnection = connection_scene.instantiate()
	
	connections.append(connection_instance)
	add_child(connection_instance)
	
	connection_instance.connect_to_port(from)
	
	return connection_instance

func delete_connection(connection : OldModularEdtiorConnection):
	connections.erase(connection)
	connection.queue_free()
