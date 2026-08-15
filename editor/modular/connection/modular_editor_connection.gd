class_name ModularEditorConnection
extends Node2D

@export var from : ModularEditorPort
@export var to : ModularEditorPort
@export var modules : Array[ModularEditorModule]

@export var highlight_line : Line2D
@export var shadow_line : Line2D

@export var point_count : int
@export var sag : float
@export var snap_radius : float

signal start_connection_search(from : ModularEditorPort)
signal stop_connection_search(to : ModularEditorPort)

func _ready() -> void:
	from.in_use = true
	from.port_down.connect(from_lifted)

func from_lifted():
	from.in_use = false
	if from.port_down.is_connected(from_lifted): from.port_down.disconnect(from_lifted)
	from = null
	start_connection_search.emit(to)

func to_lifted():
	to.in_use = false
	if to.port_down.is_connected(to_lifted): to.port_down.disconnect(to_lifted)
	to = null
	start_connection_search.emit(from)

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
			if from != null and closest_port.shape == from.shape\
			or to != null   and closest_port.shape == to.shape:
				cancel()
				return
			
			if to == null:
				to = closest_port
				to.port_down.connect(to_lifted)
				to.in_use = true
				stop_connection_search.emit(to)
			if from == null:
				from = closest_port
				from.port_down.connect(from_lifted)
				from.in_use = true
				stop_connection_search.emit(from)
			
			update_positions(from.get_global_center_position(), to.get_global_center_position())

func cancel():
	if from:
		if from.port_down.is_connected(from_lifted): from.port_down.disconnect(from_lifted)
		from.in_use = false
	if to:
		if to.port_down.is_connected(to_lifted): to.port_down.disconnect(to_lifted)
		to.in_use = false
	stop_connection_search.emit(null)
	queue_free()

func update_positions(from_position : Vector2, to_position : Vector2):
	var local_from_position := to_local(from_position)
	var local_to_position := to_local(to_position)
	highlight_line.clear_points()
	shadow_line.clear_points()
	for i in range(point_count):
		var progress : float = float(i) / float(point_count - 1)
		var point_position := calculate_point_position(local_from_position, local_to_position, progress)
		highlight_line.add_point(point_position)
		shadow_line.add_point(point_position)

func calculate_point_position(from_position : Vector2, to_position : Vector2, progress : float) -> Vector2:
	var linear_point : Vector2 = lerp(from_position, to_position, progress)
	
	var sag_offset : float = 4.0 * (progress - (progress * progress)) * sag
	
	return linear_point + Vector2(0, sag_offset)

func closest_port_to(point : Vector2) -> ModularEditorPort:
	var closest_distance : float = INF
	var closest_port : ModularEditorPort
	for module : ModularEditorModule in modules:
		for port : ModularEditorPort in module.ports:
			var distance := point.distance_to(port.get_global_center_position())
			if distance < closest_distance:
				closest_distance = distance
				closest_port = port
	
	return closest_port
