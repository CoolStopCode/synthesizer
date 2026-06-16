extends Node

@export var audio_player : AudioPlayer
@export var voice_manager : VoiceManager

@export var master_volume : float = 1.0

@export_group("Music")
@export var key : Key

@export_group("Synthesis")
#@export var voice : Voice

func _process(_delta: float) -> void:
	audio_player.process(voice_manager)

func _ready() -> void:
	build_audio()

func build_audio() -> void:
	var chords := key.get_chords()
	for chord in chords:
		print(chord.root.to_string_name(), ", ", chord.quality.type, ", ", chord.root.to_frequency())
	
	var polyvoices := VoiceBuilder.chords_to_polyvoices(chords)
	voice_manager.set_polyvoice_pool(polyvoices)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		build_audio()
