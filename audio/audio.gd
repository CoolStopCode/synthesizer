@icon("res://tools/at-icons/node/note.svg")
@abstract class_name Audio
extends AudioStreamPlayer

@abstract func process(delta : float) -> float

@abstract func build() -> void

@abstract func key_pressed(index: int) -> void
@abstract func key_released(index: int) -> void
@abstract func bend_changed(new_bend : Vector3i) -> void

@export var master_volume : float = 1.0
@export var mix_rate : int = 44100
@export var buffer_length : float = 0.03

var bend : Vector3i
var playback: AudioStreamGeneratorPlayback

func _ready() -> void:
	stream = AudioStreamGenerator.new()
	stream.mix_rate = mix_rate
	stream.buffer_length = buffer_length
	
	play()
	playback = get_stream_playback()
	
	build()

func _process(delta: float) -> void: # Generates chunks of audio processes per frame
	fill_audio_buffer()
	pass

func fill_audio_buffer() -> void:
	var frames_to_fill : int = playback.get_frames_available()
	
	for i in range(frames_to_fill):
		var sample_value : float = process(1.0 / mix_rate) * master_volume
		var frame := Vector2(sample_value, sample_value)
		
		playback.push_frame(frame)
