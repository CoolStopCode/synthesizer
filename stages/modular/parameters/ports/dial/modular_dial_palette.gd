class_name ModularDialPalette
extends ModularPortPalette

@export var notch : int
@export var notch_highlighted : int

@export var notch_connected : int
@export var outline_connected : int
@export var body_connected : int
@export var rim_connected : int
@export var hole_connected : int

func get_notch_color() -> Color:
	return get_color(notch)

func get_notch_highlighted_color() -> Color:
	return get_color(notch_connected)

func get_notch_connected_color() -> Color:
	return get_color(notch_connected)

func get_outline_connected_color() -> Color:
	return get_color(outline_connected)

func get_hole_connected_color() -> Color:
	return get_color(hole_connected)

func get_rim_connected_color() -> Color:
	return get_color(rim_connected)

func get_body_connected_color() -> Color:
	return get_color(body_connected)
