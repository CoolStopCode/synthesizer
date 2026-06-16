@tool
extends Control
signal button_pressed

@export var press_offset : int = 1

@export var icon: Texture2D :
	set(v): icon = v; if icon_node: icon_node.texture = icon
@export var light_color: Color :
	set(v): light_color = v; _update_visuals()
@export var medium_color: Color :
	set(v): medium_color = v; _update_visuals()
@export var dark_color: Color :
	set(v): dark_color = v; _update_visuals()

@export_group("private")
@export var press_node : Control
@export var base_node: NinePatchRect
@export var outline_node: NinePatchRect
@export var shadow_node: NinePatchRect
@export var icon_node: TextureRect

var is_pressed: bool = false

func _ready() -> void:
	icon_node.texture = icon
	_update_visuals()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		is_pressed = event.pressed
		if is_pressed:
			button_pressed.emit()
		_update_visuals()

func _update_visuals() -> void:
	var offset : int
	
	if is_pressed:
		base_node.self_modulate = medium_color
		outline_node.self_modulate = dark_color
		shadow_node.self_modulate = dark_color
		icon_node.self_modulate = dark_color
		
		shadow_node.visible = false
		
		offset = press_offset
	else:
		base_node.self_modulate = light_color
		outline_node.self_modulate = medium_color
		shadow_node.self_modulate = dark_color
		icon_node.self_modulate = medium_color
		
		shadow_node.visible = true
		
		offset = 0
	
	press_node.position.y = offset
