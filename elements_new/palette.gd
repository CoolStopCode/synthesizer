class_name Palette
extends Resource

@export var color_palette : ColorPalette

func get_color(index: int) -> Color:
	if color_palette.colors == null        : return Color.TRANSPARENT
	if index >= color_palette.colors.size(): return Color.TRANSPARENT
	if index < 0                           : return Color.TRANSPARENT
	
	return color_palette.colors[index]
