class_name ModularConnection
extends Node2D

var input: ModularInputElement
var output: ModularOutputElement

var dragging : bool
var dragging_finger_index : int

@export var highlight_line: Line2D
@export var shadow_line: Line2D

@export var point_count : int
@export var sag : float

func disconnect_port(port: ModularPortElement) -> void:
	if port == input:
		input.connection = null
		input.disconnected.emit()
		input = null
	
	if port == output:
		output.connection = null
		output.disconnected.emit()
		output = null
	
	update_point_positions(port.global_center_position())

func connect_port(port: ModularPortElement) -> void:
	if port is ModularInputElement:
		port.connection = self
		input = port
		port.connected.emit()
	
	if port is ModularOutputElement:
		port.connection = self
		output = port
		port.connected.emit()
	
	update_point_positions(port.global_center_position())

func can_connect_to(port: ModularPortElement) -> bool:
	if input == null and output == null: return false
	if input != null and output != null: return false
	
	if input != null:
		return input.can_connect_to(port)
	
	if output != null:
		return output.can_connect_to(port)
	
	return false

func _input(event: InputEvent) -> void:
	if not dragging: return
	
	if event is InputEventScreenDrag:
		if event.index == dragging_finger_index:
			update_point_positions(event.position)

func update_point_positions(event_position : Vector2) -> void:
	var from_position: Vector2
	var to_position: Vector2

	if input != null:
		from_position = input.global_center_position()
	else:
		from_position = event_position

	if output != null:
		to_position = output.global_center_position()
	else:
		to_position = event_position
	
	set_point_positions(from_position, to_position)

func set_point_positions(from_position: Vector2, to_position: Vector2) -> void:
	var local_from_position := to_local(from_position)
	var local_to_position := to_local(to_position)
	
	var points : PackedVector2Array
	
	for point_index in point_count:
		var progress := float(point_index) / float(point_count - 1)
	
		points.append(
			calculate_point_position(
				local_from_position,
				local_to_position,
				progress
			)
		)
	
	highlight_line.points = points
	shadow_line.points = points

func calculate_point_position(
	from_position: Vector2,
	to_position: Vector2,
	progress: float
) -> Vector2:
	var linear_point : Vector2 = lerp(from_position, to_position, progress)

	var sag_offset := (
		4.0
		* (progress - progress * progress)
		* sag
	)

	return linear_point + Vector2(0, sag_offset)
