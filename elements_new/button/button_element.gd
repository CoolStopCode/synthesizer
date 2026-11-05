class_name ButtonElement
extends BoxElement

signal pressed
signal button_down
signal button_up

@export var tooltip : String = ""
@export var tooltip_offset : Vector2

@export_group("private")
@export var tooltip_timer_node : Timer
@export var tooltip_container_node : Control
@export var tooltip_label_node : Label

@export var press_container_node: Control
@export var shadow_node: NinePatchRect

var is_pressed : bool = false
var is_hovered : bool = false

func _on_mouse_entered() -> void:
	is_hovered = true
	update()

func _on_mouse_exited() -> void:
	is_hovered = false
	update()

func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventScreenTouch:
		return

	if event.pressed:
		is_pressed = true
		button_down.emit()
		tooltip_timer_node.start()
	else:
		if is_pressed:
			is_pressed = false
			button_up.emit()
			tooltip_timer_node.stop()
			tooltip_container_node.hide()
			if is_hovered:
				pressed.emit()
	
	update()

func update() -> void:
	super()
	if is_pressed:
		fill_node.self_modulate = palette.get_fill_pressed_color()
		outline_node.self_modulate = palette.get_outline_pressed_color()
		shadow_node.self_modulate = palette.get_shadow_pressed_color()
		press_container_node.position = shape.press_offset
	else:
		fill_node.self_modulate = palette.get_fill_color()
		outline_node.self_modulate = palette.get_outline_color()
		shadow_node.self_modulate = palette.get_shadow_color()
		press_container_node.position = Vector2.ZERO
	
	shadow_node.texture = shape.shadow_texture
	
	shadow_node.patch_margin_top     = shape.margin
	shadow_node.patch_margin_bottom  = shape.margin
	shadow_node.patch_margin_left    = shape.margin
	shadow_node.patch_margin_right   = shape.margin

func _on_tooltip_timer_timeout() -> void:
	if not is_pressed: return
	if tooltip.is_empty(): return
	
	tooltip_label_node.text = tooltip
	var tooltip_minimum_size : Vector2 = tooltip_label_node.get_minimum_size()
	
	tooltip_container_node.position.x = (size.x / 2) - (tooltip_minimum_size.x / 2) - 1 + tooltip_offset.x
	tooltip_container_node.position.y = tooltip_offset.y
	tooltip_container_node.size = tooltip_minimum_size + Vector2(1, 1)
	
	tooltip_container_node.show()
