extends Control

signal button_pressed

@export var icon : Texture2D
@export var color : Color

var button_position : Vector2
var icon_position : Vector2

func _ready() -> void:
	modulate = color
	button_position = $button.position
	icon_position = $icon.position
	$icon.texture = icon

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			button_pressed.emit()
		update_visual(event.pressed)

func update_visual(pressed : bool):
	if pressed:
		self.modulate = color * 0.8
		self.modulate.a = 1.0
		$button.position.y = button_position.y + 1
		$icon.position.y = icon_position.y + 1
	else:
		self.modulate = color
		$button.position.y = button_position.y
		$icon.position.y = icon_position.y
