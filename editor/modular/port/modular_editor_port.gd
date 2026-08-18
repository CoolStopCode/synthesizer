@abstract class_name ModularEditorPort
extends Control

enum PortColor {
	FLOAT,
	AUDIO,
	BOOL
}

@export var color : PortColor
@export var click_radius : float
@export var connection : ModularEditorConnection

@export_group("private")
@export var color_table : Dictionary[PortColor, ModularEditorPortColor]
@export var hole_node: TextureRect
@export var highlight_node: TextureRect
@export var outside_node: TextureRect

func _ready() -> void:
	update_color(false)

func global_center_position() -> Vector2:
	return global_position + (size / 2)

func update_color(highlight : bool) -> void:
	var modular_editor_port_color : ModularEditorPortColor = color_table[color] 
	
	hole_node.self_modulate = modular_editor_port_color.hole_color
	
	highlight_node.self_modulate = Color(1.0, 1.0, 1.0)\
									 if highlight else\
									 modular_editor_port_color.highlight_color
	
	outside_node.self_modulate = modular_editor_port_color.outside_color

func is_compatible_with(port : ModularEditorPort) -> bool:
	if port.is_input_port() == is_input_port(): return false
	
	return true

func can_connect() -> bool:
	return is_empty()

func is_empty() -> bool:
	return connection == null

func highlight_on() -> void:
	update_color(true)
 
func highlight_off() -> void:
	update_color(false)

func in_click_area(click : Vector2) -> bool:
	return global_center_position().distance_to(click) <= click_radius

func is_input_port() -> bool:
	return self is ModularEditorInputPort

func is_output_port() -> bool:
	return self is ModularEditorOutputPort
