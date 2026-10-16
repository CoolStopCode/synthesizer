class_name ModularEditorConnection
extends Node2D

var input_port: ModularEditorInputPort
var output_port: ModularEditorOutputPort

var dragging : bool
var dragging_finger_index : int

@export var highlight_line: Line2D
@export var shadow_line: Line2D

@export var point_count : int
@export var sag : float

func disconnect_port(port: ModularEditorPort) -> void:
	if port == input_port:
		input_port.disconnected.emit()
		input_port.connection = null
		input_port = null
	
	if port == output_port:
		output_port.disconnected.emit()
		output_port.connection = null
		output_port = null
	
	update_point_positions(port.global_center_position())

func connect_port(port: ModularEditorPort) -> void:
	if port is ModularEditorInputPort:
		port.connected.emit()
		port.connection = self
		input_port = port
	
	if port is ModularEditorOutputPort:
		port.connected.emit()
		port.connection = self
		output_port = port
	
	update_point_positions(port.global_center_position())

func can_connect_to(port: ModularEditorPort) -> bool:
	if input_port == null and output_port == null: return false
	if input_port != null and output_port != null: return false
	
	if input_port != null:
		return input_port.can_connect_to(port)
	
	if output_port != null:
		return output_port.can_connect_to(port)
	
	return false

func _input(event: InputEvent) -> void:
	if not dragging: return
	
	if event is InputEventScreenDrag:
		if event.index == dragging_finger_index:
			update_point_positions(event.position)

func update_point_positions(event_position : Vector2) -> void:
	var from_position: Vector2
	var to_position: Vector2

	if input_port != null:
		from_position = input_port.global_center_position()
	else:
		from_position = event_position

	if output_port != null:
		to_position = output_port.global_center_position()
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
