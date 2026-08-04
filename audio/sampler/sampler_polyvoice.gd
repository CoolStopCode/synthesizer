class_name SamplerPolyvoice
extends RefCounted

var voices : Array[SamplerVoice]
var active : bool

var attack : float = 0.1
var release : float = 0.1

var amplitude : float = 1.0
var amplitude_fade_start : float = 1.0
var amplitude_fade_target : float = 1.0
var amplitude_fade_duration : float = 0.0
var amplitude_fade_elapsed : float = 0.0
var amplitude_fading : bool = false

var transition : float = 1.0
var transition_fade_start : float = 1.0
var transition_fade_target : float = 1.0
var transition_fade_duration : float = 0.0
var transition_fade_elapsed : float = 0.0
var transition_fading : bool = false

func polyvoice_on():
	active = true
	fade_amplitude_to(1.0, attack)
	for voice in voices:
		voice.voice_on()

func polyvoice_off():
	active = false
	fade_amplitude_to(0.0, release)
	for voice in voices:
		voice.voice_off()

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

func fade_transition_to(target: float, duration: float) -> void:
	if duration <= 0.0:
		transition = target
		transition_fading = false
		return
	transition_fade_start = transition
	transition_fade_target = target
	transition_fade_duration = duration
	transition_fade_elapsed = 0.0
	transition_fading = true

func update_amplitude_fade(delta: float) -> void:
	amplitude_fade_elapsed += delta
	var progress : float = clamp(amplitude_fade_elapsed / amplitude_fade_duration, 0.0, 1.0)
	amplitude = lerp(amplitude_fade_start, amplitude_fade_target, progress)
	if progress >= 1.0:
		amplitude_fading = false

func update_transition_fade(delta: float) -> void:
	transition_fade_elapsed += delta
	var progress : float = clamp(transition_fade_elapsed / transition_fade_duration, 0.0, 1.0)
	transition = lerp(transition_fade_start, transition_fade_target, progress)
	if progress >= 1.0:
		transition_fading = false

func bend_polyvoice(chord: Chord, chord_bend_duration : float) -> void:
	for i in voices.size():
		var voice : SamplerVoice = voices[i]
		var has_note := i < chord.semitones.size()
		
		if has_note:
			var frequency = chord.semitones[i].to_frequency()
			voice.fade_amplitude_to(1.0, chord_bend_duration)
			voice.fade_frequency_to(frequency, chord_bend_duration)
		else:
			voice.fade_amplitude_to(0.0, chord_bend_duration)

func process(delta: float) -> float:
	if amplitude_fading: update_amplitude_fade(delta)
	if transition_fading: update_transition_fade(delta)
	
	var sum : float = 0.0
	
	for voice in voices:
		var value = voice.process(delta)
		sum += value
	
	return (sum / voices.size()) * amplitude * transition
