class_name ModularEditorDial
extends ModularEditorInputPort

@export var notch : Control

var previous_mouse_position : Vector2
var dragging : bool = false

#func _gui_input(event: InputEvent) -> void:
	#super._gui_input(event)
	#if in_use: return
	#
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#previous_mouse_position = event.global_position
			#dragging = true
		#else:
			#dragging = false
	#
	#if event is InputEventMouseMotion or event is InputEventScreenDrag:
		#if dragging:
			#notch.rotation += (event.global_position - previous_mouse_position).x / 12
			#previous_mouse_position = event.global_position
