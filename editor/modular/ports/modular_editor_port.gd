@abstract class_name ModularEditorPort
extends Control
 
@export var outline : TextureRect
@export var port : TextureRect

signal pressed
signal released

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			pressed.emit()
		else:
			released.emit()
