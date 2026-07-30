class_name Tooltip
extends Control

@export var label : Label
static var instance: Tooltip

func _ready() -> void:
	instance = self
	hide()

static func create_tooltip(_text: String, _position: Vector2) -> void:
	if _text == "":
		return

	instance.label.text = _text
	

	var minimum_size : Vector2 = instance.label.get_minimum_size()
	instance.size = minimum_size + Vector2(1, 1)
	
	instance.position.x = _position.x - (minimum_size.x / 2) - 1
	instance.position.y = _position.y
	
	instance.show()

static func clear_tooltip() -> void:
	instance.hide()
