class_name ModularEditorConnection
extends Node2D

@export var from : InterfacePort
@export var to : InterfacePort
@export var line : Line2D
@export var modules_parent : Control
@export var snap_radius : float

func _ready() -> void:
	from.in_use = true
	from.port_down.connect(from_lifted)

func from_lifted():
	from.in_use = false
	if from.port_down.is_connected(from_lifted): from.port_down.disconnect(from_lifted)
	from = null

func to_lifted():
	to.in_use = false
	if to.port_down.is_connected(to_lifted): to.port_down.disconnect(to_lifted)
	to = null

func _input(event: InputEvent) -> void:
	if from == null and to == null: return
	if from != null and to != null: return
	
	if event is InputEventScreenDrag or event is InputEventMouseMotion:
		var from_position := from.get_global_center_position() if from != null else get_global_mouse_position()
		var to_position := to.get_global_center_position() if to != null else get_global_mouse_position()
		update_positions(from_position, to_position)
	
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			pass
		else:
			var closest_port := closest_port_to(get_global_mouse_position())
			var closest_port_position := closest_port.get_global_center_position()
			var closest_port_distance := get_global_mouse_position().distance_to(closest_port_position)
			if closest_port_distance > snap_radius:
				cancel()
				return
			if closest_port == from and from != null\
			or closest_port == to   and to != null:
				cancel()
				return
			if closest_port.in_use:
				cancel()
				return
			
			if to == null:
				to = closest_port
				to.port_down.connect(to_lifted)
				to.in_use = true
			if from == null:
				from = closest_port
				from.port_down.connect(from_lifted)
				from.in_use = true
			
			update_positions(from.get_global_center_position(), to.get_global_center_position())

func cancel():
	if from:
		from.port_down.disconnect(from_lifted)
		from.in_use = false
	if to:
		to.port_down.disconnect(from_lifted)
		to.in_use = false
	queue_free()
	
func update_positions(from_position : Vector2, to_position : Vector2):
	var local_from_position := to_local(from_position)
	var local_to_position := to_local(to_position)
	line.set_point_position(0, local_from_position)
	line.set_point_position(1, local_to_position)

func closest_port_to(point : Vector2) -> InterfacePort:
	var closest_distance : float = INF
	var closest_port : InterfacePort
	for module : ModularEditorModule in modules_parent.get_children():
		for port : InterfacePort in module.ports:
			var distance := point.distance_to(port.get_global_center_position())
			if distance < closest_distance:
				closest_distance = distance
				closest_port = port
	
	return closest_port
