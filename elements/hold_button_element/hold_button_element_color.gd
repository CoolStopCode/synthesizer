class_name HoldButtonElementColor
extends ButtonElementColor

@export_group("Unpressed")
@export var progress_unpressed : int = -1

@export_group("Pressed")
@export var progress_pressed : int = 0

func get_progress_color(pressed: bool) -> Color:
	var index : int = progress_pressed if pressed else progress_unpressed
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]
