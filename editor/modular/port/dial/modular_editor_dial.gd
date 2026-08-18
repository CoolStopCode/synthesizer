class_name ModularEditorDial
extends ModularEditorInputPort

@export var minimum_value : float
@export var maximum_value : float
@export var minimum_rotation : float
@export var maximum_rotation : float
@export var rotation_speed : float
@export var dial_rotation : float

@export_group("private")
@export var notch : Control

var previous_mouse_position : Vector2
var dragging : bool = false

func clicked() -> void:
	previous_mouse_position = get_global_mouse_position()
	dragging = true

func _input(event: InputEvent) -> void:
	if not dragging: return
	
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		dial_rotation += (event.global_position - previous_mouse_position).x * rotation_speed
		previous_mouse_position = event.global_position
		notch.rotation = clamp(dial_rotation, deg_to_rad(minimum_rotation), deg_to_rad(maximum_rotation))
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if not event.is_pressed():
			dragging = false
			dial_rotation = clamp(dial_rotation, deg_to_rad(minimum_rotation), deg_to_rad(maximum_rotation))

func get_value() -> float:
	var progress := inverse_lerp(minimum_rotation, maximum_rotation, dial_rotation)
	var value := lerpf(minimum_value, maximum_value, progress)
	value = clamp(value, minimum_value, maximum_value)
	
	return value
