class_name TextButtonElement
extends ButtonElement

@export var text: String

@export_group("private")
@export var text_node: Label

func update() -> void:
	super()
	
	if is_pressed:
		text_node.self_modulate = palette.get_text_pressed_color()
	else:
		text_node.self_modulate = palette.get_text_color()
	
	text_node.label_settings = shape.get_label_settings()
	text_node.text = text
