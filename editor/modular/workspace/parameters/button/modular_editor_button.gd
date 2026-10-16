class_name ModularEditorButton
extends ModularEditorParameter

@export var icons : Array[Texture]
@export var tooltip : String
@export var color : ButtonElementColor
@export var shape : ButtonElementShape

@export_group("private")
@export var button : ButtonElement

func _ready() -> void:
	button.tooltip = tooltip
	button.color = color
	button.shape = shape
	button.update_visuals()
	update_button_icon()

func _on_button_element_pressed() -> void:
	var new_value := float((int(value) + 1) % icons.size())
	value = new_value
	update_button_icon()

func update_button_icon() -> void:
	button.icon = icons[int(value)]
	button.update_visuals()

func set_value(_value : float) -> void:
	value = _value
	update_button_icon()

func get_value() -> float:
	return value
