class_name Tooltip2
extends MarginContainer

@export var label : RichTextLabel
static var instance: Tooltip2

func _ready() -> void:
	instance = self

static func create_tooltip(_text: String, _position: Vector2) -> void:
	if _text == "":
		return
	instance.label.text = _text
	instance.position = _position
	var width := instance.size.x
	
	instance.show()

static func clear_tooltip() -> void:
	instance.hide()
