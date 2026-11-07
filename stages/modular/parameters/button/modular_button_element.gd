class_name ModularButtonElement
extends ModularParameterElement

@export var icons : Array[Texture]
@export var tooltip : String

@export_group("private")
@export var button_node : ButtonElement

func _ready() -> void:
	button_node.tooltip = tooltip
	button_node.palette = palette
	button_node.shape = shape
	update()

func _on_button_pressed() -> void:
	var new_value := float((int(value) + 1) % icons.size())
	value = new_value
	update()

func update() -> void:
	button_node.icon = icons[int(value)]
	button_node.update()

func set_value(_value : float) -> void:
	value = _value
	update()

func get_value() -> float:
	return value
