class_name AudioEngine
extends Node

@export var key : Key
@export var audio_mode : AudioMode

@export_group("Nodes")
@export var audio_player : AudioPlayer

@export_group("Audio Properties")
@export var master_volume : float = 1.0
@export var tune : float = 440.0
@export var mix_rate : int = 44100
@export var buffer_length : float = 0.03

func _process(_delta: float) -> void:
	audio_player.fill_audio_buffer(audio_mode)

func _ready() -> void:
	build_audio()

func build_audio() -> void:
	var scale := key.build_scale()
	
	var chords : Array[Chord]
	for i in range(7):
		var chord : Chord = scale.triad(i)
		chords.append(chord)
		
		var names : Array = chord.semitones.map(func(s): return s.to_string_name())
		print(", ".join(names))
	
	audio_mode.scale = scale
	audio_mode.build()

func key_pressed(index: int) -> void:
	audio_mode.key_pressed(index)

func key_released(index: int) -> void:
	audio_mode.key_released(index)

func bend_changed(bend : Vector3i) -> void:
	audio_mode.bend = bend
	audio_mode.bend_changed()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		build_audio()
