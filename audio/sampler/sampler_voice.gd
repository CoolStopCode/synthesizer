class_name SamplerAudioVoice
extends RefCounted

var audio_stream : PackedFloat32Array
var sample_rate : float = 44100.0
var base_frequency : float = 440.0

var playback : float = 0.0
var active : bool = false

var amplitude : float = 1.0
var amplitude_fade_start : float = 1.0
var amplitude_fade_target : float = 1.0
var amplitude_fade_duration : float = 0.0
var amplitude_fade_elapsed : float = 0.0
var amplitude_fading : bool = false

var frequency : float = 1.0
var frequency_fade_start : float = 1.0
var frequency_fade_target : float = 1.0
var frequency_fade_duration : float = 0.0
var frequency_fade_elapsed : float = 0.0
var frequency_fading : bool = false

var ghost_active : bool = false
var ghost_playback : float = 0.0

var ghost_amplitude : float = 0.0
var ghost_fade_start : float = 0.0
var ghost_fade_target : float = 0.0
var ghost_fade_duration : float = 0.0
var ghost_fade_elapsed : float = 0.0
var ghost_fading : bool = false

func voice_on() -> void:
	if active:
		ghost_playback = playback
		ghost_amplitude = amplitude
		ghost_active = true
		fade_ghost_to(0.0, 0.1)
	
	playback = 0.0
	active = true
	amplitude_fading = false

func voice_off() -> void:
	pass

func fade_ghost_to(target: float, duration: float) -> void:
	if duration <= 0.0:
		ghost_amplitude = target
		ghost_fading = false
		return
	ghost_fade_start = ghost_amplitude
	ghost_fade_target = target
	ghost_fade_duration = duration
	ghost_fade_elapsed = 0.0
	ghost_fading = true

func update_ghost_fade(delta: float) -> void:
	ghost_fade_elapsed += delta
	var progress : float = clamp(ghost_fade_elapsed / ghost_fade_duration, 0.0, 1.0)
	ghost_amplitude = lerp(ghost_fade_start, ghost_fade_target, progress)
	if progress >= 1.0:
		ghost_fading = false

func update_amplitude_fade(delta: float) -> void:
	amplitude_fade_elapsed += delta
	var progress : float = clamp(amplitude_fade_elapsed / amplitude_fade_duration, 0.0, 1.0)
	amplitude = lerp(amplitude_fade_start, amplitude_fade_target, progress)
	if progress >= 1.0:
		amplitude_fading = false

func update_frequency_fade(delta: float) -> void:
	frequency_fade_elapsed += delta
	var progress : float = clamp(frequency_fade_elapsed / frequency_fade_duration, 0.0, 1.0)
	frequency = lerp(frequency_fade_start, frequency_fade_target, progress)
	if progress >= 1.0:
		frequency_fading = false

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

func fade_frequency_to(target: float, duration: float) -> void:
	if duration <= 0.0:
		frequency = target
		frequency_fading = false
		return
	frequency_fade_start = frequency   # fixed: was "amplitude"
	frequency_fade_target = target
	frequency_fade_duration = duration
	frequency_fade_elapsed = 0.0
	frequency_fading = true

func process(delta : float) -> float:
	if not active:
		return 0.0
	
	var pitch_ratio : float = frequency / base_frequency
	var advance := sample_rate * delta * pitch_ratio
	
	if amplitude_fading: update_amplitude_fade(delta)
	if frequency_fading: update_frequency_fade(delta)
	if ghost_fading:
		update_ghost_fade(delta)
		ghost_playback += advance

		if ghost_playback >= audio_stream.size() - 1:
			ghost_fading = false
	
	playback += advance

	if playback >= audio_stream.size() - 1:
		active = false
		return 0.0
	
	var sample : float = 0.0
	
	if ghost_fading:
		sample += audio_stream[int(playback)] * amplitude
		sample += audio_stream[int(ghost_playback)] * ghost_amplitude
	else:
		sample = audio_stream[int(playback)] * amplitude

	return sample
