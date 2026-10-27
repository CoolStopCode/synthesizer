class_name ToolComposeAudio
extends Node

@export var tonal_audio : TonalAudio
@export var key : CompositionKey
@export var print_notes : bool

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		tonal_audio.scale = key.build_scale()
		
		if print_notes:
			for i in range(tonal_audio.polyvoice_count):
				print(tonal_audio.scale.get_semitone(i).to_string_name())
