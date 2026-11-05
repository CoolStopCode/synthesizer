class_name IconPalette
extends Palette

@export var icon : int

func get_icon_color() -> Color:
	return get_color(icon)
