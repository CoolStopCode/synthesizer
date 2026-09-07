class_name Main
extends Control

@export var audio_mode : AudioMode
@export var editor_mode : EditorMode

func _ready() -> void: # temporary
	editor_mode.audio_mode = $AudioEngine.audio_mode
