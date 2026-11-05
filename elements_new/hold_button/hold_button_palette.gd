class_name HoldButtonPalette
extends IconButtonPalette

@export var progress : int

func get_progress_color() -> Color:
	return get_color(progress)
