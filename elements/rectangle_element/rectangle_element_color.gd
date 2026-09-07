class_name RectangleElementColor
extends Resource

@export var palette : ColorPalette

@export var fill : int = 2
@export var outline : int = 1

func get_outline_color() -> Color:
	var index : int = outline
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]

func get_fill_color() -> Color:
	var index : int = fill
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]
