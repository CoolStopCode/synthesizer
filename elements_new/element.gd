@abstract class_name Element
extends Control

@export var palette : Palette
@export var shape : Shape

func _ready() -> void:
	update()

@abstract func update() -> void
