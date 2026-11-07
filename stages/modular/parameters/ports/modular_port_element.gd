@abstract class_name ModularPortElement
extends ModularParameterElement

@export var click_radius : float
@export var can_create_connection : bool

@export_group("private")
@export var outline_node: TextureRect
@export var body_node: TextureRect
@export var rim_node: TextureRect
@export var hole_node: TextureRect

var connection : ModularConnection
var is_highlighted : bool

signal pressed(event : InputEvent)
signal connected
signal disconnected

func highlight_on():
	is_highlighted = true
	update()

func highlight_off():
	is_highlighted = false
	update()

func global_center_position():
	return global_position + (size / 2)

func update() -> void:
	if is_highlighted:
		outline_node.self_modulate = palette.get_outline_highlighted_color()
		body_node.self_modulate    = palette.get_body_highlighted_color()
		rim_node.self_modulate     = palette.get_rim_highlighted_color()
		hole_node.self_modulate    = palette.get_hole_highlighted_color()
	else:
		outline_node.self_modulate = palette.get_outline_color()
		body_node.self_modulate    = palette.get_body_color()
		rim_node.self_modulate     = palette.get_rim_color()
		hole_node.self_modulate    = palette.get_hole_color()
	
	outline_node.texture = shape.get_outline_texture()
	body_node.texture    = shape.get_body_texture()
	rim_node.texture     = shape.get_rim_texture()
	hole_node.texture    = shape.get_hole_texture()

func has_connection() -> bool:
	return connection != null

func in_click_radius(point : Vector2):
	return global_center_position().distance_to(point) <= click_radius

func can_connect_to(port : ModularPortElement) -> bool:
	if has_connection(): return false
	if (self is ModularInputElement) == (port is ModularInputElement): return false
	
	return true
