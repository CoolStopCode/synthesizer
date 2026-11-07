class_name ModularDialShape
extends ModularPortShape

@export var notch : Texture2D

@export var notch_open : Texture2D
@export var outline_open : Texture2D
@export var body_open : Texture2D
@export var rim_open : Texture2D
@export var hole_open : Texture2D

func get_notch_texture() -> Texture:
	return notch

func get_notch_open_texture() -> Texture:
	return notch_open

func get_outline_open_texture() -> Texture:
	return outline_open

func get_body_open_texture() -> Texture:
	return body_open

func get_rim_open_texture() -> Texture:
	return rim_open

func get_hole_open_texture() -> Texture:
	return hole_open
