class_name ModularPortPalette
extends Palette

@export var outline : int
@export var body : int
@export var rim : int
@export var hole : int

@export var outline_highlighted : int
@export var body_highlighted : int
@export var rim_highlighted : int
@export var hole_highlighted : int

func get_outline_color() -> Color:
	return get_color(outline)

func get_hole_color() -> Color:
	return get_color(hole)

func get_rim_color() -> Color:
	return get_color(rim)

func get_body_color() -> Color:
	return get_color(body)

func get_outline_highlighted_color() -> Color:
	return get_color(outline_highlighted)

func get_hole_highlighted_color() -> Color:
	return get_color(hole_highlighted)

func get_rim_highlighted_color() -> Color:
	return get_color(rim_highlighted)

func get_body_highlighted_color() -> Color:
	return get_color(body_highlighted)
