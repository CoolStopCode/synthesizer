class_name ModularButton
extends ModularParameter

@export var icons : Array[Texture]
@export var tooltip : String
@export var palette : ButtonPalette
@export var shape : ButtonShape

@export_group("private")
@export var button : ButtonElement

func _ready() -> void:
	button.tooltip = tooltip
	button.palette = palette
	button.shape = shape
	update()

func _on_button_pressed() -> void:
	var new_value := float((int(value) + 1) % icons.size())
	value = new_value
	update()

func update() -> void:
	button.icon = icons[int(value)]
	button.update()

func set_value(_value : float) -> void:
	value = _value
	update()

func get_value() -> float:
	return value
