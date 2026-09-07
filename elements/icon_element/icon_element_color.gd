class_name IconElementColor
extends Resource

@export var palette : ColorPalette
@export var icon : int = 0

func get_icon_color() -> Color:
	var index : int = icon
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]
