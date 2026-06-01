extends Node

@export var audio_player : AudioPlayer
@export var voice_manager : VoiceManager

@export var master_volume : float

@export_category("Music")
@export var key : Key

@export_category("Synthesis")
@export var envelope : Envelope
@export var voice_properties : VoiceProperties

func _physics_process(_delta: float) -> void:
	audio_player.process(voice_manager)

func _ready() -> void:
	var chords := key.get_chords()
	#for chord in chords:
		#print(chord.root.to_string_name(), ", ", chord.quality)
	var voices := VoiceBuilder.chords_to_voices(chords, envelope, voice_properties)
	voice_manager.set_voice_pool(voices)
