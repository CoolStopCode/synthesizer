class_name ModularEditorDialPort
extends ModularEditorInputPort

@export var minimum_value : float
@export var maximum_value : float
@export var minimum_rotation : float
@export var maximum_rotation : float
@export var rotation_speed : float
@export var dial_rotation : float

@export_group("private")
@export var hole_disconnected_texture : Texture2D
@export var rim_disconnected_texture : Texture2D
@export var body_connected_texture : Texture2D
@export var hole_connected_texture : Texture2D
@export var rim_connected_texture : Texture2D
@export var body_disconnected_texture : Texture2D
@export var notch_node : TextureRect

var previous_mouse_position : Vector2
var dragging : bool = false

var raw_rotation : float

func _input(event: InputEvent) -> void:
	if not dragging:
		return
	
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		raw_rotation += (event.global_position - previous_mouse_position).x * rotation_speed
		previous_mouse_position = event.global_position
		dial_rotation = clamp(raw_rotation, minimum_rotation, maximum_rotation)
		notch_node.rotation = dial_rotation
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if not event.is_pressed():
			dragging = false

func clicked() -> void:
	previous_mouse_position = get_global_mouse_position()
	raw_rotation = dial_rotation
	dragging = true

func connected() -> void:
	hole_node.texture = hole_connected_texture
	rim_node.texture = rim_connected_texture
	body_node.texture = body_connected_texture
	notch_node.hide()

func disconnected() -> void:
	hole_node.texture = hole_disconnected_texture
	rim_node.texture = rim_disconnected_texture
	body_node.texture = body_disconnected_texture
	notch_node.show()

func update_color(highlighted : bool) -> void:
	super.update_color(highlighted)
	notch_node.self_modulate = color.get_hole_color(highlighted)

func set_value(_value : float) -> void:
	value = _value
	var progress := inverse_lerp(minimum_value, maximum_value, value)
	dial_rotation = clamp(lerpf(minimum_rotation, maximum_rotation, progress), minimum_rotation, maximum_rotation)
	notch_node.rotation_degrees = dial_rotation

func get_value() -> float:
	var progress := inverse_lerp(minimum_rotation, maximum_rotation, dial_rotation)
	var out_value := clampf(lerpf(minimum_value, maximum_value, progress), minimum_value, maximum_value)
	return out_value
