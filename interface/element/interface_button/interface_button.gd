class_name InterfaceButton
extends Control

signal pressed
signal button_down
signal button_up

@export var icon: Texture2D
@export var tooltip : String = ""

@export var interface_button_color: InterfaceButtonColor
@export var interface_button_shape: InterfaceButtonShape

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
	if not (event is InputEventMouseButton or event is InputEventScreenTouch):
		return

	if event.pressed:
		is_pressed = true
		button_down.emit()
		tooltip_timer.start()
	else:
		if is_pressed:
			is_pressed = false
			button_up.emit()
			tooltip_timer.stop()
			if is_hovered:
				pressed.emit()
			Tooltip.clear_tooltip()
	
	update_visuals()

func update_visuals() -> void:
	fill_node.self_modulate = interface_button_color.get_fill_color(is_pressed)
	outline_node.self_modulate = interface_button_color.get_outline_color(is_pressed)
	shadow_node.self_modulate = interface_button_color.get_shadow_color(is_pressed)
	icon_node.self_modulate = interface_button_color.get_icon_color(is_pressed)
	
	fill_node.texture = interface_button_shape.fill_texture
	outline_node.texture = interface_button_shape.outline_texture
	shadow_node.texture = interface_button_shape.shadow_texture
	
	press_node.position = interface_button_shape.get_offset(is_pressed)
	
	fill_node.patch_margin_top       = interface_button_shape.margin
	fill_node.patch_margin_bottom    = interface_button_shape.margin
	fill_node.patch_margin_left      = interface_button_shape.margin
	fill_node.patch_margin_right     = interface_button_shape.margin
	outline_node.patch_margin_top    = interface_button_shape.margin
	outline_node.patch_margin_bottom = interface_button_shape.margin
	outline_node.patch_margin_left   = interface_button_shape.margin
	outline_node.patch_margin_right  = interface_button_shape.margin
	shadow_node.patch_margin_top     = interface_button_shape.margin
	shadow_node.patch_margin_bottom  = interface_button_shape.margin
	shadow_node.patch_margin_left    = interface_button_shape.margin
	shadow_node.patch_margin_right   = interface_button_shape.margin
	
	icon_node.texture = icon

func _on_tooltip_timer_timeout() -> void:
	if is_pressed and not tooltip.is_empty():
		var tooltip_position : Vector2
		tooltip_position.x = global_position.x + size.x / 2
		tooltip_position.y = global_position.y
		Tooltip.create_tooltip(tooltip, tooltip_position)
