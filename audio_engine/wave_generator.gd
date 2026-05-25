extends Node
class_name WaveGenerator

const SAMPLE_RATE := 44000.0
const BUFFER_LENGTH := 0.03
const MASTER_VOLUME := 0.15

var playback : AudioStreamGeneratorPlayback
@export var output : AudioStreamPlayer

var active_chord : Chord

func _ready() -> void:
	setup()

func setup() -> void:
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = SAMPLE_RATE
	generator.buffer_length = BUFFER_LENGTH

	output.stream = generator
	output.play()

	playback = output.get_stream_playback()

func _process(_delta: float) -> void:
	fill_buffer()

func fill_buffer() -> void:
	if active_chord == null:
		return
	
	var frames := playback.get_frames_available()

	for i in range(frames):
		var mixed_sample := 0.0
		for voice : Voice in active_chord.voices:
			# Sine wave oscillator
			var sample := voice.evaluate()
			mixed_sample += sample * voice.volume
			voice.phase = fmod(voice.phase + voice.frequency / SAMPLE_RATE, 1.0)
			
		# Prevent clipping
		mixed_sample /= max(active_chord.voices.size(), 1)
		mixed_sample *= MASTER_VOLUME
		playback.push_frame(Vector2(mixed_sample, mixed_sample))
