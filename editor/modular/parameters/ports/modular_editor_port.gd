@abstract class_name ModularEditorPort
extends ModularEditorParameter

@export var color : ModularEditorPortColor
@export var click_radius : float
@export var can_create_connection : bool

@export_group("private")
@export var outline_node: TextureRect
@export var body_node: TextureRect
@export var rim_node: TextureRect
@export var hole_node: TextureRect

var connection : ModularEditorConnection

func global_center_position():
	return global_position + (size / 2)

func _ready() -> void:
	update_color(false)

func update_color(highlighted : bool) -> void:
	hole_node.self_modulate = color.get_hole_color(highlighted)
	rim_node.self_modulate = color.get_rim_color(highlighted)
	body_node.self_modulate = color.get_body_color(highlighted)
	outline_node.self_modulate = color.get_outline_color(highlighted)

func highlight_on() -> void:
	update_color(true)
 
func highlight_off() -> void:
	update_color(false)

func is_compatible_with(port : ModularEditorPort) -> bool:
	return port.is_input_port() != is_input_port()

func is_disconnected() -> bool:
	return connection == null

func in_click_radius(point : Vector2):
	return global_center_position().distance_to(point) <= click_radius

func can_connect_to(port : ModularEditorPort) -> bool:
	return is_disconnected() and is_compatible_with(port)

func is_input_port() -> bool:
	return self is ModularEditorInputPort

func is_output_port() -> bool:
	return self is ModularEditorOutputPort

func clicked() -> void: pass
func connected() -> void: pass
func disconnected() -> void: pass
