class_name AudioEngine
extends AudioStreamPlayer

@export var audio_mode : AudioMode

@export_group("Audio Properties")
@export var master_volume : float = 1.0
@export var tune : float = 440.0
@export var mix_rate : int = 44100
@export var buffer_length : float = 0.03

var playback: AudioStreamGeneratorPlayback

func _ready() -> void:
	build()

func build():
	stream = AudioStreamGenerator.new()
	stream.mix_rate = mix_rate
	stream.buffer_length = buffer_length
	
	play()
	playback = get_stream_playback()
	
	audio_mode.build()

func key_pressed(index: int)  -> void: audio_mode.key_pressed(index)
func key_released(index: int) -> void: audio_mode.key_released(index)

func bend_changed(bend : Vector3i) -> void:
	audio_mode.bend = bend
	audio_mode.bend_changed()

func _process(delta: float) -> void: # Generates chunks of audio processes per frame
	fill_audio_buffer()
	pass

func fill_audio_buffer() -> void:
	var frames_to_fill : int = playback.get_frames_available()
	
	for i in range(frames_to_fill):
		var sample_value : float = audio_mode.process(1.0 / mix_rate) * master_volume
		var frame := Vector2(sample_value, sample_value)
		
		playback.push_frame(frame)
