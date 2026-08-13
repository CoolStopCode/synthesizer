class_name ModularEditorPort
extends Control

signal pressed
signal port_down
signal port_up

@export var in_use : bool
@export var interface_port_data: ModularEditorPortData

@export_group("private")
@export var hole_node: TextureRect
@export var highlight_node: TextureRect
@export var outside_node: TextureRect
@export var outline_node: TextureRect

var is_pressed : bool = false
var is_hovered : bool = false

func _ready() -> void:
	update_visuals()

func _on_mouse_entered() -> void:
	is_hovered = true
	update_visuals()

func _on_mouse_exited() -> void:
	is_hovered = false
	update_visuals()

func get_global_center_position() -> Vector2:
	return global_position + (size / 2)
func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT): return

	if event.pressed: # Press
		is_pressed = true
		port_down.emit()
	else: # Release
		if is_pressed:
			is_pressed = false
			port_up.emit()
			if is_hovered: pressed.emit()
	
	update_visuals()

func update_visuals() -> void:
	hole_node.texture = interface_port_data.hole_texture
	highlight_node.texture = interface_port_data.highlight_texture
	outside_node.texture = interface_port_data.outside_texture
	outline_node.texture = interface_port_data.outline_texture
	
	hole_node.self_modulate = interface_port_data.hole_color
	highlight_node.self_modulate = interface_port_data.highlight_color
	outside_node.self_modulate = interface_port_data.outside_color
	outline_node.self_modulate = interface_port_data.outline_color
	
	outline_node.visible = is_pressed and in_use

func is_input_port():
	return interface_port_data.is_input_port()

func is_output_port():
	return interface_port_data.is_output_port()
