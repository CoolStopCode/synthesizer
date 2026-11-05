class_name BoxShape
extends Shape

@export var margin : int

@export var fill_texture : Texture
@export var outline_texture : Texture

func get_fill_texture() -> Texture:
	return fill_texture

func get_outline_texture() -> Texture:
	return outline_texture
