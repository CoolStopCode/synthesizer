class_name ButtonElement
extends Control

signal pressed
signal button_down
signal button_up

@export var icon: Texture2D
@export var tooltip : String = ""

@export var color: ButtonElementColor
@export var shape: ButtonElementShape

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
	
	update_visuals()

func update_visuals() -> void:
	fill_node.self_modulate = color.get_fill_color(is_pressed)
	outline_node.self_modulate = color.get_outline_color(is_pressed)
	shadow_node.self_modulate = color.get_shadow_color(is_pressed)
	icon_node.self_modulate = color.get_icon_color(is_pressed)
	
	fill_node.texture = shape.fill_texture
	outline_node.texture = shape.outline_texture
	shadow_node.texture = shape.shadow_texture
	
	press_node.position = shape.get_offset(is_pressed)
	
	fill_node.patch_margin_top       = shape.margin
	fill_node.patch_margin_bottom    = shape.margin
	fill_node.patch_margin_left      = shape.margin
	fill_node.patch_margin_right     = shape.margin
	outline_node.patch_margin_top    = shape.margin
	outline_node.patch_margin_bottom = shape.margin
	outline_node.patch_margin_left   = shape.margin
	outline_node.patch_margin_right  = shape.margin
	shadow_node.patch_margin_top     = shape.margin
	shadow_node.patch_margin_bottom  = shape.margin
	shadow_node.patch_margin_left    = shape.margin
	shadow_node.patch_margin_right   = shape.margin
	
	icon_node.texture = icon

#func _on_tooltip_timer_timeout() -> void:
	#if is_pressed and not tooltip.is_empty():
		#var tooltip_position : Vector2
		#tooltip_position.x = global_position.x + size.x / 2
		#tooltip_position.y = global_position.y
		#Tooltip.create_tooltip(tooltip, tooltip_position)
