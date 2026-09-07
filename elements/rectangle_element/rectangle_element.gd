class_name RectangleElement
extends Control

@export var color: RectangleElementColor
@export var shape: RectangleElementShape

@export_group("private")
@export var fill_node: NinePatchRect
@export var outline_node: NinePatchRect

func _ready() -> void:
	update_visuals()

func update_visuals() -> void:
	fill_node.self_modulate = color.get_fill_color()
	outline_node.self_modulate = color.get_outline_color()
	
	fill_node.texture = shape.fill_texture
	outline_node.texture = shape.outline_texture
	
	fill_node.patch_margin_top       = shape.margin
	fill_node.patch_margin_bottom    = shape.margin
	fill_node.patch_margin_left      = shape.margin
	fill_node.patch_margin_right     = shape.margin
	outline_node.patch_margin_top    = shape.margin
	outline_node.patch_margin_bottom = shape.margin
	outline_node.patch_margin_left   = shape.margin
	outline_node.patch_margin_right  = shape.margin
