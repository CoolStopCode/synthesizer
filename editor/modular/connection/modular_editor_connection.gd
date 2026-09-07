class_name ModularEditorConnection
extends Node2D

var input_port: ModularEditorInputPort
var output_port: ModularEditorOutputPort

@export var highlight_line: Line2D
@export var shadow_line: Line2D

@export var point_count := 20
@export var sag := 20.0


func lift_port(port: ModularEditorPort) -> void:
	if port == input_port:
		input_port.disconnected()
		input_port.connection = null
		input_port = null

	if port == output_port:
		output_port.disconnected()
		output_port.connection = null
		output_port = null


func can_connect_to(port: ModularEditorPort) -> bool:
	return port.can_connect_to(get_connected_port())


func get_connected_port() -> ModularEditorPort:
	if input_port != null and output_port != null:
		return null

	if input_port != null:
		return input_port

	if output_port != null:
		return output_port

	return null


func connect_to(port: ModularEditorPort) -> void:
	port.connection = self
	port.connected()

	if port.is_input_port():
		input_port = port
	elif port.is_output_port():
		output_port = port

	update_positions()


func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseMotion or event is InputEventScreenDrag):
		return

	if input_port == null and output_port == null:
		return

	if input_port != null and output_port != null:
		return

	update_positions()


func update_positions() -> void:
	var from_position: Vector2
	var to_position: Vector2

	if input_port != null:
		from_position = input_port.global_center_position()
	else:
		from_position = get_global_mouse_position()

	if output_port != null:
		to_position = output_port.global_center_position()
	else:
		to_position = get_global_mouse_position()

	set_positions(from_position, to_position)


func set_positions(from_position: Vector2, to_position: Vector2) -> void:
	var local_from_position := to_local(from_position)
	var local_to_position := to_local(to_position)
	
	var points := PackedVector2Array()
	
	for i in point_count:
		var progress := float(i) / float(point_count - 1)
	
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
