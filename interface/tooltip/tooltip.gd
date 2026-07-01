class_name Tooltip
extends MarginContainer

@export var label : RichTextLabel
static var instance: Tooltip

func _ready() -> void:
	instance = self

static func create_tooltip(_text: String, _position: Vector2) -> void:
	if _text == "":
		return
	instance.label.text = _text
	instance.position = _position
	instance.show()

static func clear_tooltip() -> void:
	instance.hide()
