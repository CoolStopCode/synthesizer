@abstract class_name ModularEditorPort
extends Control

enum PortColor {
	FLOAT,
	AUDIO,
	BOOL
}

var connection : ModularEditorConnection

@export var color : PortColor
@export var click_radius : float
@export var can_create_connection : bool

@export_group("private")
@export var color_table : Dictionary[PortColor, ModularEditorPortColor]
@export var hole_node: TextureRect
@export var rim_node: TextureRect
@export var body_node: TextureRect

func _ready() -> void:
	update_color(false)

func global_center_position() -> Vector2:
	return global_position + (size / 2)

func update_color(highlighted : bool) -> void:
	var modular_editor_port_color : ModularEditorPortColor = color_table[color]
	
	var black := modular_editor_port_color.black_color
	var dark := modular_editor_port_color.dark_color
	var medium := modular_editor_port_color.medium_color
	var light := modular_editor_port_color.light_color
	var highlight := modular_editor_port_color.highlight_color
	
	hole_node.self_modulate = black
	rim_node.self_modulate = highlight if highlighted else light
	body_node.self_modulate = medium

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

func clicked() -> void: pass
func connected() -> void: pass
func disconnected() -> void: pass
