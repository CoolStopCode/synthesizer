class_name ButtonElementColor
extends Resource

@export var palette : ColorPalette

@export_group("Unpressed")
@export var fill_unpressed : int = 2
@export var shadow_unpressed : int = 0
@export var outline_unpressed : int = 1
@export var icon_unpressed : int = 1

@export_group("Pressed")
@export var fill_pressed : int = 1
@export var shadow_pressed : int = -1
@export var outline_pressed : int = 0
@export var icon_pressed : int = 0

func get_outline_color(pressed: bool) -> Color:
	var index : int = outline_pressed if pressed else outline_unpressed
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]

func get_icon_color(pressed: bool) -> Color:
	var index : int = icon_pressed if pressed else icon_unpressed
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]

func get_fill_color(pressed: bool) -> Color:
	var index : int = fill_pressed if pressed else fill_unpressed
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]

func get_shadow_color(pressed: bool) -> Color:
	var index : int = shadow_pressed if pressed else shadow_unpressed
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]
