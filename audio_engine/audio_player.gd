extends AudioStreamPlayer
class_name AudioPlayer

@export var audio_engine : AudioEngine
@export var output : AudioStreamPlayer

var playback: AudioStreamGeneratorPlayback

var mix_rate: float
var master_volume: float
var sample_delta: float

func _ready() -> void:
	mix_rate = audio_engine.mix_rate
	master_volume = audio_engine.master_volume
	sample_delta = 1.0 / mix_rate
	
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = mix_rate
	generator.buffer_length = audio_engine.buffer_length
	
	output.stream = generator
	output.play()
	playback = output.get_stream_playback()

func fill_audio_buffer(audio_mode: AudioMode) -> void:
	var frames_to_fill := playback.get_frames_available()
	
	while frames_to_fill > 0: 
		var sample_value : float = audio_mode.process(sample_delta) * master_volume
		var frame := Vector2(sample_value, sample_value)
		
		playback.push_frame(frame)
		frames_to_fill -= 1
