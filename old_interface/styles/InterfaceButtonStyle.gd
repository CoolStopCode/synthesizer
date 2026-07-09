class_name ButtonStyle
extends Resource

enum ButtonType {
	NORMAL,
	HOLLOW
}

const HIDDEN_COLOR = Color(0.0, 0.0, 0.0, 0.0)
const DEBUG_COLOR = Color.PURPLE

@export var button_type : ButtonType
@export var press_offset : int = 1
@export var light_color : Color
@export var medium_color : Color
@export var dark_color : Color

func get_outline_color(pressed : bool) -> Color:
	match button_type:
		ButtonType.NORMAL:
			if pressed:
				return dark_color
			else:
				return medium_color
		ButtonType.HOLLOW:
			return light_color
	
	return DEBUG_COLOR

func get_icon_color(pressed : bool) -> Color:
	match button_type:
		ButtonType.NORMAL:
			if pressed:
				return dark_color
			else:
				return medium_color
		ButtonType.HOLLOW:
			return light_color
	
	return DEBUG_COLOR

func get_fill_color(pressed : bool) -> Color:
	match button_type:
		ButtonType.NORMAL:
			if pressed:
				return medium_color
			else:
				return light_color
		ButtonType.HOLLOW:
			if pressed:
				return dark_color
			else:
				return HIDDEN_COLOR
	
	return DEBUG_COLOR

func get_shadow_color(pressed : bool) -> Color:
	match button_type:
		ButtonType.NORMAL:
			if pressed:
				return HIDDEN_COLOR
			else:
				return dark_color
		ButtonType.HOLLOW:
			return HIDDEN_COLOR
	
	return DEBUG_COLOR

func get_offset(pressed : bool) -> int:
	if pressed:
		return press_offset
	else:
		return 0
