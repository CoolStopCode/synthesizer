class_name VoiceManager
extends Node

@export var max_polyphony: int = 12
@export var master_gain: float = 0.2

var voice_pool: Array[Voice] = []
var steal_index: int = 0


func _ready() -> void:
	for i in range(max_polyphony):
		var voice := Voice.new(
			Oscillator.new(Waveform.Enum.SQUARE),
			Envelope.new()
		)

		voice_pool.append(voice)


func activate_voice(voice: Voice, frequency: float, note_id: int) -> void:
	voice.note_id = note_id
	voice.oscillator.frequency = frequency
	voice.note_on()


func note_on(frequency: float, note_id: int) -> void:
	# Find free voice first
	for voice in voice_pool:
		if voice.envelope.state == Envelope.State.IDLE:
			activate_voice(voice, frequency, note_id)
			return

	# Round-robin voice stealing
	var stolen_voice := voice_pool[steal_index]

	activate_voice(stolen_voice, frequency, note_id)

	steal_index = (steal_index + 1) % max_polyphony


func note_off(note_id: int) -> void:
	for voice in voice_pool:
		if voice.note_id == note_id and voice.is_pressed:
			voice.note_off()
			return


func process_mix(delta: float) -> float:
	var mixed_sample := 0.0

	for voice in voice_pool:
		mixed_sample += voice.process(delta)

	# Gain scaling + clipping protection
	return clampf(mixed_sample * master_gain, -1.0, 1.0)
