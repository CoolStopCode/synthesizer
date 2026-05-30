extends AudioStreamPlayer
class_name AudioPlayer

@export var output : AudioStreamPlayer = self

var playback: AudioStreamGeneratorPlayback

const SAMPLE_RATE := 44100.0

func _ready() -> void:
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = 44100.0 # Standard CD quality
	generator.buffer_length = 0.025
	
	output.stream = generator
	output.play()
	playback = output.get_stream_playback()

func process(voice_manager : VoiceManager) -> void:
	if not playback:
		return
	
	var frames_to_fill := playback.get_frames_available()
	var sample_delta := 1.0 / SAMPLE_RATE
	
	while frames_to_fill > 0: 
		var sample_value : float = voice_manager.process_mix(sample_delta) * AudioEngine.master_volume
		sample_value = clamp(sample_value, -1.0, 1.0)
		var frame := Vector2(sample_value, sample_value)
		
		playback.push_frame(frame)
		frames_to_fill -= 1
