extends Node

@export var audio_player : AudioPlayer
@export var voice_manager : VoiceManager

@export_category("Music")
@export var key : Key

@export_category("Synthesis")
@export var envelope : Envelope
@export var waveform : Waveform.Enum

func _process(delta: float) -> void:
	audio_player.process(voice_manager)

func _ready() -> void:
	print(key.root)
	var chords := key.get_chords(false)
	var voices := VoiceBuilder.chords_to_voices(chords)
	voice_manager.build_voice_pool(voices)
