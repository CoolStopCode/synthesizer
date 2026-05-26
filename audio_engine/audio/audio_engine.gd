extends Node

@export var voice_manager: VoiceManager
@export var output : AudioStreamPlayer

var playback: AudioStreamGeneratorPlayback

const SAMPLE_RATE := 44100.0

func _ready() -> void:
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = 44100.0 # Standard CD quality
	generator.buffer_length = 0.03 # 100ms latency buffer
	
	output.stream = generator
	output.play()
	playback = output.get_stream_playback()

func _physics_process(_delta: float) -> void:
	if not playback:
		return
	
	var frames_to_fill := playback.get_skips() + playback.get_frames_available()
	
	var sample_delta := 1.0 / SAMPLE_RATE
	
	while frames_to_fill > 0:
		var sample_value := voice_manager.process_mix(sample_delta)
		
		var frame := Vector2(sample_value, sample_value)
		
		playback.push_frame(frame)
		frames_to_fill -= 1
