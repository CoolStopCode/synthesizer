class_name ModularEditorPort
extends Control

enum PortShape {
	INPUT,
	OUTPUT
}

enum PortColor {
	FLOAT,
	AUDIO,
	BOOL
}

signal port_down
signal port_up

@export var color : PortColor
@export var shape : PortShape

var in_use : bool

@export_group("private")
@export var color_table : Dictionary[PortColor, ModularEditorPortColor]
@export var shape_table : Dictionary[PortShape, ModularEditorPortShape]
@export var hole_node: TextureRect
@export var highlight_node: TextureRect
@export var outside_node: TextureRect

func _ready() -> void:
	update_visuals()

func get_global_center_position() -> Vector2:
	return global_position + (size / 2)

func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT): return

	if event.pressed:
		port_down.emit()
	else:
		port_up.emit()

func update_visuals() -> void:
	var modular_editor_port_color : ModularEditorPortColor = color_table[color] 
	var modular_editor_port_shape : ModularEditorPortShape = shape_table[shape]
	
	hole_node.texture = modular_editor_port_shape.hole_texture
	highlight_node.texture = modular_editor_port_shape.highlight_texture
	outside_node.texture = modular_editor_port_shape.outside_texture
	
	hole_node.self_modulate = modular_editor_port_color.hole_color
	highlight_node.self_modulate = modular_editor_port_color.highlight_color
	outside_node.self_modulate = modular_editor_port_color.outside_color

func start_connection_search(from : ModularEditorPort) -> void:
	if from.shape != shape:
		highlight_node.self_modulate = Color(1.0, 1.0, 1.0)

func stop_connection_search(to : ModularEditorPort) -> void:
	highlight_node.self_modulate = color_table[color].highlight_color
