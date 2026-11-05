class_name ButtonPalette
extends BoxPalette

@export var shadow : int

@export var shadow_pressed : int
@export var fill_pressed : int
@export var outline_pressed : int

func get_shadow_color() -> Color:
	return get_color(shadow)

func get_shadow_pressed_color() -> Color:
	return get_color(shadow_pressed)

func get_fill_pressed_color() -> Color:
	return get_color(fill_pressed)

func get_outline_pressed_color() -> Color:
	return get_color(outline_pressed)
