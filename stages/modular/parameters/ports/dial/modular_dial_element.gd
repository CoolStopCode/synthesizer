class_name ModularDialElement
extends ModularInputElement

@export var minimum_value : float
@export var maximum_value : float
@export var minimum_rotation : float
@export var maximum_rotation : float
@export var rotation_speed : float
@export var dial_rotation : float

@export_group("private")
@export var notch_node : TextureRect

var previous_mouse_position : Vector2
var is_dragging : bool = false
var dragging_finger_index : int
var raw_rotation : float

func _input(event: InputEvent) -> void:
	if not (event is InputEventScreenDrag or event is InputEventScreenTouch): return
	
	if not is_dragging:
		return
	
	if not event.index == dragging_finger_index:
		return
	
	if event is InputEventScreenDrag:
		raw_rotation += (event.position - previous_mouse_position).x * rotation_speed
		previous_mouse_position = event.position
		dial_rotation = clamp(raw_rotation, minimum_rotation, maximum_rotation)
		notch_node.rotation = dial_rotation
	
	if event is InputEventScreenTouch:
		if not event.is_pressed():
			is_dragging = false

func set_value(_value : float) -> void:
	value = _value
	var progress := inverse_lerp(minimum_value, maximum_value, value)
	dial_rotation = clamp(lerpf(minimum_rotation, maximum_rotation, progress), minimum_rotation, maximum_rotation)
	notch_node.rotation = dial_rotation

func get_value() -> float:
	var progress := inverse_lerp(minimum_rotation, maximum_rotation, dial_rotation)
	var out_value := clampf(lerpf(minimum_value, maximum_value, progress), minimum_value, maximum_value)
	return out_value

func _on_disconnected() -> void:
	update()

func _on_connected() -> void:
	update()

func _on_pressed(event: InputEvent) -> void:
	previous_mouse_position = event.position
	raw_rotation = dial_rotation
	is_dragging = true
	dragging_finger_index = event.index

func update() -> void:
	super()
	
	if is_highlighted or has_connection():
		notch_node.texture   = shape.get_notch_open_texture()
		outline_node.texture = shape.get_outline_open_texture()
		body_node.texture    = shape.get_body_open_texture()
		rim_node.texture     = shape.get_rim_open_texture()
		hole_node.texture    = shape.get_hole_open_texture()
		
		if is_highlighted:
			notch_node.self_modulate   = palette.get_notch_highlighted_color()
			outline_node.self_modulate = palette.get_outline_highlighted_color()
			body_node.self_modulate    = palette.get_body_highlighted_color()
			rim_node.self_modulate     = palette.get_rim_highlighted_color()
			hole_node.self_modulate    = palette.get_hole_highlighted_color()
		else:
			notch_node.self_modulate   = palette.get_notch_connected_color()
			outline_node.self_modulate = palette.get_outline_connected_color()
			body_node.self_modulate    = palette.get_body_connected_color()
			rim_node.self_modulate     = palette.get_rim_connected_color()
			hole_node.self_modulate    = palette.get_hole_connected_color()
	else:
		notch_node.texture   = shape.get_notch_texture()
		outline_node.texture = shape.get_outline_texture()
		body_node.texture    = shape.get_body_texture()
		rim_node.texture     = shape.get_rim_texture()
		hole_node.texture    = shape.get_hole_texture()
		
		notch_node.self_modulate   = palette.get_notch_color()
		outline_node.self_modulate = palette.get_outline_color()
		body_node.self_modulate    = palette.get_body_color()
		rim_node.self_modulate     = palette.get_rim_color()
		hole_node.self_modulate    = palette.get_hole_color()
