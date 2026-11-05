class_name TextButtonElement
extends ButtonElement

@export var text: String

@export_group("private")
@export var text_node: Label

func update() -> void:
	super()
	text_node.text = text
