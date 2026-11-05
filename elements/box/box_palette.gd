class_name BoxPalette
extends Palette

@export var fill : int
@export var outline : int

func get_fill_color() -> Color:
	return get_color(fill)

func get_outline_color() -> Color:
	return get_color(outline)
