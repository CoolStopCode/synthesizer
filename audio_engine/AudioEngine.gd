extends Node

@export var audio_player : AudioPlayer
@export var voice_manager : VoiceManager

@export_category("Music")
@export var key : Key

@export_category("Synthesis")
@export var envelope : Envelope
@export var waveform : Waveform.Enum

func _physics_process(_delta: float) -> void:
	audio_player.process(voice_manager)

func _ready() -> void:
	var chords := key.get_chords(false)
	for chord in chords:
		print(chord.root.to_string_name(), " ", chord.quality)
	var voices := VoiceBuilder.chords_to_voices(chords, envelope, waveform)
	voice_manager.build_voice_pool(voices)
