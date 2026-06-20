extends Node

@export_group("Nodes")
@export var audio_player : AudioPlayer

@export_group("Audio Properties")
@export var master_volume : float = 1.0
@export var mix_rate : int = 44100
@export var buffer_length : float = 0.03

@export_group("")
@export var key : Key
@export var audio_mode : AudioMode

func _process(_delta: float) -> void:
	audio_player.fill_audio_buffer(audio_mode)

func _ready() -> void:
	build_audio()

func build_audio() -> void:
	var chords := key.get_chords()
	for chord in chords:
		print(chord.root.to_string_name(), ", ", chord.quality.type, ", ", chord.root.to_frequency())
	
	audio_mode.build(chords)

func key_pressed(index: int) -> void:
	audio_mode.key_pressed(index)

func key_released(index: int) -> void:
	audio_mode.key_released(index)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		build_audio()
