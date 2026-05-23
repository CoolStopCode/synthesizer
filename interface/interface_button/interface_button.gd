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
}

var textures := {
	ButtonColor.BLUE: {
		ButtonState.NORMAL: preload("res://interface/interface_button/button/blue.png"),
		ButtonState.PRESSED: preload("res://interface/interface_button/button/blue_pressed.png"),
	},

	ButtonColor.RED: {
		ButtonState.NORMAL: preload("res://interface/interface_button/button/red.png"),
		ButtonState.PRESSED: preload("res://interface/interface_button/button/red_pressed.png"),
	},

	ButtonColor.WHITE: {
		ButtonState.NORMAL: preload("res://interface/interface_button/button/white.png"),
		ButtonState.PRESSED: preload("res://interface/interface_button/button/white_pressed.png"),
	},

	ButtonColor.YELLOW: {
		ButtonState.NORMAL: preload("res://interface/interface_button/button/yellow.png"),
		ButtonState.PRESSED: preload("res://interface/interface_button/button/yellow_pressed.png"),
	}
}

@export var icon : Texture2D
@export var icon_pressed : Texture2D

@export var button_color : ButtonColor:
	set(value):
		button_color = value
		_update_texture()

@export var pressed : bool = false
@export var hovered : bool = false
@export var button_node : TextureRect
@export var icon_node : TextureRect


func _ready() -> void:
	_update_texture()

func _update_texture() -> void:
	var state : ButtonState
	
	if pressed:
		state = ButtonState.PRESSED
	else:
		state = ButtonState.NORMAL
	
	button_node.texture = textures[button_color][state]
	icon_node.texture = icon_pressed if pressed else icon
	icon_node.position.y = 6 if pressed else 5

func _set_state(state_pressed : bool):
	pressed = state_pressed
	_update_texture()

func _gui_input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		_set_state(event.pressed)
