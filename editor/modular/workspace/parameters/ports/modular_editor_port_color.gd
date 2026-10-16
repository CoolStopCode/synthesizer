class_name ModularEditorPortColor
extends Resource

@export var palette : ColorPalette

@export_group("unhighlighted")
@export var outline_unhighlighted : int
@export var body_unhighlighted : int
@export var rim_unhighlighted : int
@export var hole_unhighlighted : int

@export_group("highlighted")
@export var outline_highlighted : int
@export var body_highlighted : int
@export var rim_highlighted : int
@export var hole_highlighted : int

func get_outline_color(highlighted : bool) -> Color:
	var index : int = outline_highlighted if highlighted else outline_unhighlighted
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]

func get_hole_color(highlighted: bool) -> Color:
	var index : int = hole_highlighted if highlighted else hole_unhighlighted
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]

func get_rim_color(highlighted: bool) -> Color:
	var index : int = rim_highlighted if highlighted else rim_unhighlighted
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]

func get_body_color(highlighted: bool) -> Color:
	var index : int = body_highlighted if highlighted else body_unhighlighted
	if (index == -1): return Color(0, 0, 0, 0)
	else:             return palette.colors[index]
