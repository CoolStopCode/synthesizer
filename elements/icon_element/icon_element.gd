class_name IconElement
extends Control

@export var icon: Texture2D

@export var color: IconElementColor

@export_group("private")
@export var icon_node: TextureRect

func _ready() -> void:
	update_visuals()

func update_visuals() -> void:
	icon_node.self_modulate = color.get_icon_color()
	
	icon_node.texture = icon
