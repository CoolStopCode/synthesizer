class_name IconButtonPalette
extends ButtonPalette

@export var icon : int
@export var icon_pressed : int

func get_icon_color() -> Color:
	return get_color(icon)

func get_icon_pressed_color() -> Color:
	return get_color(icon_pressed)
