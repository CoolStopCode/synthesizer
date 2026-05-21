@tool
class_name InterfaceButton
extends Control

enum ButtonColor {
	BLUE,
	RED,
	WHITE,
	YELLOW
}

enum ButtonState {
	NORMAL,
	PRESSED,
	HOVERED
}

var textures := {
	ButtonColor.BLUE: {
		ButtonState.NORMAL: preload("res://interface/interface_button/apollo4/blue.png"),
		ButtonState.PRESSED: preload("res://interface/interface_button/apollo4/blue_pressed.png"),
		ButtonState.HOVERED: preload("res://interface/interface_button/apollo4/blue_hovered.png")
	},

	ButtonColor.RED: {
		ButtonState.NORMAL: preload("res://interface/interface_button/apollo4/red.png"),
		ButtonState.PRESSED: preload("res://interface/interface_button/apollo4/red_pressed.png"),
		ButtonState.HOVERED: preload("res://interface/interface_button/apollo4/red_hovered.png")
	},

	ButtonColor.WHITE: {
		ButtonState.NORMAL: preload("res://interface/interface_button/apollo4/white.png"),
		ButtonState.PRESSED: preload("res://interface/interface_button/apollo4/white_pressed.png"),
		ButtonState.HOVERED: preload("res://interface/interface_button/apollo4/white_hovered.png")
	},

	ButtonColor.YELLOW: {
		ButtonState.NORMAL: preload("res://interface/interface_button/apollo4/yellow.png"),
		ButtonState.PRESSED: preload("res://interface/interface_button/apollo4/yellow_pressed.png"),
		ButtonState.HOVERED: preload("res://interface/interface_button/apollo4/yellow_hovered.png")
	}
}

@export var button_color : ButtonColor:
	set(value):
		button_color = value
		_update_texture()

@export var pressed : bool = false
@export var hovered : bool = false
@export var texture_node : TextureRect


func _ready() -> void:
	_update_texture()

func _update_texture() -> void:
	var state : ButtonState
	if pressed:
		state = ButtonState.PRESSED
	elif hovered:
		state = ButtonState.HOVERED
	else:
		state = ButtonState.NORMAL
	
	print(state)
	texture_node.texture = textures[button_color][state]


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			pressed = event.pressed
			_update_texture()
