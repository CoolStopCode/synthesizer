class_name ToolComposeAudio
extends Node

@export var tonal_audio : TonalAudio
@export var key : CompositionKey
@export var print_notes : bool

func _ready() -> void:
	tonal_audio.scale = key.build_scale()
	
	if print_notes:
		for i in range(tonal_audio.polyvoice_count):
			print(tonal_audio.scale.get_semitone(i).to_string_name())
