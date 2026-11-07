class_name ModularPortShape
extends Shape

@export var outline : Texture2D
@export var body : Texture2D
@export var rim : Texture2D
@export var hole : Texture2D

func get_outline_texture() -> Texture:
	return outline

func get_body_texture() -> Texture:
	return body

func get_rim_texture() -> Texture:
	return rim

func get_hole_texture() -> Texture:
	return hole
