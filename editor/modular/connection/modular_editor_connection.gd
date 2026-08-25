class_name ModularEditorConnection
extends Node2D

@export var input : ModularEditorInputPort
@export var output : ModularEditorOutputPort

@export var highlight_line : Line2D
@export var shadow_line : Line2D

@export var point_count : int
@export var sag : float

func lift_port(port : ModularEditorPort) -> void:
	if port != input and port != output: return
	port.disconnected()
	
	if port == input:
		input.connection = null
		input = null
	if port == output:
		output.connection = null
		output = null

func can_connect_to(port : ModularEditorPort) -> bool:
	return port.can_connect_to(get_connected_port())

func get_connected_port() -> ModularEditorPort:
	if input != null and output != null: return
	
	if input != null: return input
	if output != null: return output
	
	return null

func connect_to_port(port : ModularEditorPort) -> void:
	port.connection = self
	port.connected()
	
	if port.is_input_port():
		input = port
	if port.is_output_port():
		output = port
	
	update_positions()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if input == null and output == null: return
		if input != null and output != null: return
		
		update_positions()

func update_positions() -> void:
	if input == null and output == null: return
	
	var from_position: Vector2
	var to_position: Vector2
	
	if input != null:
		from_position = input.global_center_position()
	else:
		from_position = get_global_mouse_position()
	
	if output != null:
		to_position = output.global_center_position()
	else:
		to_position = get_global_mouse_position()
	
	set_positions(from_position, to_position)

func set_positions(from_position : Vector2, to_position : Vector2) -> void:
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
