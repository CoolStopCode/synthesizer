class_name InterfaceButtonStyle
extends Resource

enum ButtonType { NORMAL, HOLLOW }
enum ColorRole { LIGHT, MEDIUM, DARK, HIDDEN }
enum PartRole { OUTLINE, ICON, FILL, SHADOW }

@export var button_type : ButtonType
@export var press_offset : int = 1
@export var light_color : Color
@export var medium_color : Color
@export var dark_color : Color

# ButtonType -> PartRole -> [unpressed, pressed]
const STYLE_TABLE : Dictionary = {
	ButtonType.NORMAL: {
		PartRole.OUTLINE: [ColorRole.MEDIUM, ColorRole.DARK],
		PartRole.ICON:    [ColorRole.MEDIUM, ColorRole.DARK],
		PartRole.FILL:    [ColorRole.LIGHT,  ColorRole.MEDIUM],
		PartRole.SHADOW:  [ColorRole.DARK,   ColorRole.HIDDEN],
	},
	ButtonType.HOLLOW: {
		PartRole.OUTLINE: [ColorRole.LIGHT,  ColorRole.LIGHT],
		PartRole.ICON:    [ColorRole.LIGHT,  ColorRole.LIGHT],
		PartRole.FILL:    [ColorRole.HIDDEN, ColorRole.DARK],
		PartRole.SHADOW:  [ColorRole.HIDDEN, ColorRole.HIDDEN],
	},
}

func get_outline_color(pressed: bool) -> Color:
	return resolve_color_role(color_role_for(PartRole.OUTLINE, pressed))

func get_icon_color(pressed: bool) -> Color:
	return resolve_color_role(color_role_for(PartRole.ICON, pressed))

func get_fill_color(pressed: bool) -> Color:
	return resolve_color_role(color_role_for(PartRole.FILL, pressed))

func get_shadow_color(pressed: bool) -> Color:
	return resolve_color_role(color_role_for(PartRole.SHADOW, pressed))

func get_offset(pressed: bool) -> int:
	return press_offset if pressed else 0

func color_role_for(part_role : PartRole, pressed: bool) -> ColorRole:
	var entry = STYLE_TABLE.get(button_type).get(part_role)
	return entry[1 if pressed else 0]

func resolve_color_role(color_role : ColorRole) -> Color:
	match color_role:
		ColorRole.LIGHT: return light_color
		ColorRole.MEDIUM: return medium_color
		ColorRole.DARK: return dark_color
		ColorRole.HIDDEN: return Color(0, 0, 0, 0)
	return Color.WHITE
