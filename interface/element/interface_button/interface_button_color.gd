class_name InterfaceButtonColor
extends Resource

enum ColorRole { LIGHT, MEDIUM, DARK, HIDDEN }

@export_group("Colors")
@export var light_color : Color
@export var medium_color : Color
@export var dark_color : Color

@export_group("Unpressed")
@export var fill_unpressed : ColorRole = ColorRole.LIGHT
@export var shadow_unpressed : ColorRole = ColorRole.DARK
@export var outline_unpressed : ColorRole = ColorRole.MEDIUM
@export var icon_unpressed : ColorRole = ColorRole.MEDIUM


@export_group("Pressed")
@export var fill_pressed : ColorRole = ColorRole.MEDIUM
@export var shadow_pressed : ColorRole = ColorRole.HIDDEN
@export var outline_pressed : ColorRole = ColorRole.DARK
@export var icon_pressed : ColorRole = ColorRole.DARK

func get_outline_color(pressed: bool) -> Color:
	return resolve_color_role(outline_pressed if pressed else outline_unpressed)

func get_icon_color(pressed: bool) -> Color:
	return resolve_color_role(icon_pressed if pressed else icon_unpressed)

func get_fill_color(pressed: bool) -> Color:
	return resolve_color_role(fill_pressed if pressed else fill_unpressed)

func get_shadow_color(pressed: bool) -> Color:
	return resolve_color_role(shadow_pressed if pressed else shadow_unpressed)

func resolve_color_role(color_role : ColorRole) -> Color:
	match color_role:
		ColorRole.LIGHT: return light_color
		ColorRole.MEDIUM: return medium_color
		ColorRole.DARK: return dark_color
		ColorRole.HIDDEN: return Color(0, 0, 0, 0)
	return Color.WHITE
