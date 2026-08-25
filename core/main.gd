class_name Main
extends Control

@export var editor_mode : EditorMode

func _ready() -> void: # temporary
	editor_mode.audio_mode = $AudioEngine.audio_mode

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		$AudioEngine.audio_mode.layout = editor_mode.build_layout()
		print($AudioEngine.audio_mode.layout.memory_data)
