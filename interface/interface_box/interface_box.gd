class_name InterfaceBox
extends Control

@export var interface_box_style: InterfaceBoxStyle

@export_group("private")
@export var fill_node: NinePatchRect
@export var outline_node: NinePatchRect

func _ready() -> void:
	update_visuals()

func update_visuals() -> void:
	fill_node.self_modulate = interface_box_style.get_fill_color()
	outline_node.self_modulate = interface_box_style.get_outline_color()
