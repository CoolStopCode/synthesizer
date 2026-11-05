class_name TextButtonPalette
extends ButtonPalette

@export var text : int
@export var text_pressed : int

func get_text_color() -> Color:
	return get_color(text)

func get_text_pressed_color() -> Color:
	return get_color(text_pressed)
