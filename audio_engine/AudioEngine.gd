extends Node

@export var audio_player : AudioPlayer
@export var voice_manager : VoiceManager

@export var master_volume : float = 1.0

@export_category("Music")
@export var key : Key

@export_category("Synthesis")
@export var sound : Sound

func _physics_process(_delta: float) -> void:
	audio_player.process(voice_manager)

func _ready() -> void:
	build_audio()

func build_audio() -> void:
	var chords := key.get_chords()
	for chord in chords:
		print(chord.root.to_string_name(), ", ", chord.quality.type)
	
	var voices := VoiceBuilder.chords_to_voices(chords, sound)
	print("After:", voices[0].get_instance_id())
	voice_manager.set_voice_pool(voices)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		print("Before:", voice_manager.voice_pool[0].get_instance_id())
		build_audio()
