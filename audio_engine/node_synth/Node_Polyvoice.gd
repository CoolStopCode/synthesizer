class_name Node_Polyvoice
extends RefCounted

var voices : Array[Node_Voice]
var active : bool
var amplitude : float = 1.0

var amplitude_fade_start : float = 1.0
var amplitude_fade_target : float = 1.0
var amplitude_fade_duration : float = 0.0
var amplitude_fade_elapsed : float = 0.0
var amplitude_fading : bool = false

func polyvoice_on():
	active = true
	for voice in voices:
		voice.active = true

func polyvoice_off():
	active = false
	for voice in voices:
		voice.active = false

func fade_amplitude_to(target: float, duration: float) -> void:
	if duration <= 0.0:
		amplitude = target
		amplitude_fading = false
		return
	amplitude_fade_start = amplitude
	amplitude_fade_target = target
	amplitude_fade_duration = duration
	amplitude_fade_elapsed = 0.0
	amplitude_fading = true

func set_amplitude_to(value: float) -> void:
	amplitude = value
	amplitude_fading = false

func update_amplitude_fade(delta: float) -> void:
	amplitude_fade_elapsed += delta
	var t : float = clamp(amplitude_fade_elapsed / amplitude_fade_duration, 0.0, 1.0)
	amplitude = lerp(amplitude_fade_start, amplitude_fade_target, t)
	if t >= 1.0:
		amplitude_fading = false

func bend_polyvoice(chord: Chord, chord_bend_duration : float) -> void:
	for i in voices.size():
		var voice : Node_Voice = voices[i]
		var has_note := i < chord.semitones.size()
		
		if not has_note:
			voice.bend_amplitude_to(0.0, chord_bend_duration)
		if has_note:
			var frequency = chord.semitones[i].to_frequency()
			voice.bend_amplitude_to(1.0, chord_bend_duration)
			voice.bend_frequency_to(frequency, chord_bend_duration)

func process(delta: float) -> float:
	if amplitude_fading:
		update_amplitude_fade(delta)
	
	var sum : float = 0.0
	
	for voice in voices:
		var value = voice.process(delta)
		sum += value
	
	return (sum / sqrt(voices.size())) * 0.2 * amplitude
