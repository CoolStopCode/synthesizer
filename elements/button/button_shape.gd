class_name ButtonShape
extends BoxShape

@export var press_offset : Vector2
@export var shadow_texture : Texture

func get_shadow_texture() -> Texture:
	return shadow_texture
