class_name IconButtonElement
extends ButtonElement

@export var icon: Texture2D

@export_group("private")
@export var icon_node: TextureRect

func update() -> void:
	super()
	
	if is_pressed:
		icon_node.self_modulate = palette.get_icon_color()
	else:
		icon_node.self_modulate = palette.get_icon_color()
	
	icon_node.texture = icon
