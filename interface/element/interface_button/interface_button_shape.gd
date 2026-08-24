class_name InterfaceButtonShape
extends Resource

@export var press_offset : Vector2 = Vector2(0, 1)

@export var fill_texture : Texture
@export var shadow_texture : Texture
@export var outline_texture : Texture

@export var margin : int

func get_offset(pressed: bool) -> Vector2:
	return press_offset if pressed else Vector2(0, 0)
