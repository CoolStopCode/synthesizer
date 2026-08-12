class_name InterfaceBoxStyle
extends Resource

@export var light_color : Color
@export var medium_color : Color
@export var dark_color : Color

func get_outline_color() -> Color:
	return medium_color

func get_fill_color() -> Color:
	return light_color
