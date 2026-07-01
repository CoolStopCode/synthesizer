class_name InterfaceButton
extends Control

signal button_pressed

@export var icon: Texture2D
@export var button_style: ButtonStyle
@export_multiline var tooltip : String = ""

@export_group("private")
@export var press_node: Control
@export var fill_node: NinePatchRect
@export var outline_node: NinePatchRect
@export var shadow_node: NinePatchRect
@export var icon_node: TextureRect

var is_pressed := false
var time_since_pressed := 0.0
const TOOLTIP_TIME := 0.5

func _ready() -> void:
	icon_node.texture = icon
	_update_visuals()

func _process(delta: float) -> void:
	if not is_pressed:
		return
	time_since_pressed += delta
	if time_since_pressed >= TOOLTIP_TIME:
		Tooltip.create_tooltip(tooltip, global_position)

func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventScreenTouch or event is InputEventMouseButton):
		return
	is_pressed = event.pressed
	if is_pressed:
		button_pressed.emit()
	else:
		time_since_pressed = 0.0
		Tooltip.clear_tooltip()
	_update_visuals()

func _update_visuals() -> void:
	outline_node.self_modulate = button_style.get_outline_color(is_pressed)
	icon_node.self_modulate   = button_style.get_icon_color(is_pressed)
	fill_node.self_modulate   = button_style.get_fill_color(is_pressed)
	shadow_node.self_modulate = button_style.get_shadow_color(is_pressed)
	press_node.position.y     = button_style.get_offset(is_pressed)
