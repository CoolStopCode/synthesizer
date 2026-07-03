class_name Tooltip
extends Control

@export var label : RichTextLabel
static var instance: Tooltip

func _ready() -> void:
	instance = self
	hide()

static func create_tooltip(_text: String, _position: Vector2) -> void:
	if _text == "":
		return

	instance.label.text = _text
	

	var width := instance.label.get_content_width()
	var height := instance.label.get_content_height()
	instance.size = Vector2(width + 1, height + 1)
	
	instance.position.x = _position.x - (width + 2) / 2
	instance.position.y = _position.y
	
	instance.show()

static func clear_tooltip() -> void:
	instance.hide()
