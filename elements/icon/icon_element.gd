class_name IconElement
extends Element

@export var icon : Texture
@export var icon_node : TextureRect

func update() -> void:
	icon_node.texture = icon
	icon_node.self_modulate = palette.get_icon_color()
