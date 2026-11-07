class_name BoxShape
extends Shape

@export var margin : int

@export var fill : Texture
@export var outline : Texture

func get_fill_texture() -> Texture:
	return fill

func get_outline_texture() -> Texture:
	return outline
