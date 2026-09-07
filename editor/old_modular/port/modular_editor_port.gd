@abstract class_name OldModularEdtiorPort
extends Control

var connection : OldModularEdtiorConnection

@export var color : OldModularEdtiorPortColor
@export var click_radius : float
@export var can_create_connection : bool

@export_group("private")
@export var outline_node: TextureRect
@export var body_node: TextureRect
@export var rim_node: TextureRect
@export var hole_node: TextureRect

func _ready() -> void:
	update_color(false)

func global_center_position() -> Vector2:
	return global_position + (size / 2)

func update_color(highlighted : bool) -> void:
	hole_node.self_modulate = color.get_hole_color(highlighted)
	rim_node.self_modulate = color.get_rim_color(highlighted)
	body_node.self_modulate = color.get_body_color(highlighted)
	outline_node.self_modulate = color.get_outline_color(highlighted)

func is_compatible_with(port : OldModularEdtiorPort) -> bool:
	if port.is_input_port() == is_input_port(): return false
	
	return true

func can_connect_to(port : OldModularEdtiorPort) -> bool:
	return is_empty() and is_compatible_with(port)

func is_empty() -> bool:
	return connection == null

func highlight_on() -> void:
	update_color(true)
 
func highlight_off() -> void:
	update_color(false)

func in_click_area(click : Vector2) -> bool:
	return global_center_position().distance_to(click) <= click_radius

func is_input_port() -> bool:
	return self is OldModularEdtiorInputPort

func is_output_port() -> bool:
	return self is OldModularEdtiorOutputPort

func clicked() -> void: pass
func connected() -> void: pass
func disconnected() -> void: pass
