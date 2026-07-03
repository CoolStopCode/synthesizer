class_name InterfaceButton
extends Control

signal pressed
signal button_down
signal button_up

@export var icon: Texture2D
@export var interface_button_style: InterfaceButtonStyle
@export_multiline var tooltip : String = ""

@export_group("private")
@export var tooltip_timer : Timer
@export var press_node: Control
@export var fill_node: NinePatchRect
@export var outline_node: NinePatchRect
@export var shadow_node: NinePatchRect
@export var icon_node: TextureRect

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


func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		return

	if event.pressed:
		is_pressed = true
		button_down.emit()
		tooltip_timer.start()
		update_visuals()
	else:
		if is_pressed:
			is_pressed = false
			button_up.emit()
			tooltip_timer.stop()
			if is_hovered:
				pressed.emit()
			update_visuals()
			Tooltip.clear_tooltip()

func is_visually_pressed() -> bool:
	return is_pressed and is_hovered

func update_visuals() -> void:
	var is_pressed_visual := is_visually_pressed()
	
	fill_node.self_modulate = interface_button_style.get_fill_color(is_pressed_visual)
	outline_node.self_modulate = interface_button_style.get_outline_color(is_pressed_visual)
	shadow_node.self_modulate = interface_button_style.get_shadow_color(is_pressed_visual)
	icon_node.self_modulate = interface_button_style.get_icon_color(is_pressed_visual)
	
	icon_node.texture = icon

	press_node.position.y = interface_button_style.get_offset(is_pressed_visual)


func _on_tooltip_timer_timeout() -> void:
	if is_pressed and not tooltip.is_empty():
		var tooltip_position : Vector2
		tooltip_position.x = global_position.x + size.x / 2
		tooltip_position.y = global_position.y
		Tooltip.create_tooltip(tooltip, tooltip_position)
