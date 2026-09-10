class_name Main
extends Control

@export var editor_mode : EditorMode
@export var audio_mode : AudioMode

func _ready() -> void:
	editor_mode.audio_mode = audio_mode
