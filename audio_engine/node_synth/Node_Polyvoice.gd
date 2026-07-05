class_name Node_Polyvoice
extends RefCounted

var voices : Array[Node_Voice]
var active : bool

var amplitude : float = 1.0
var amplitude_start : float = 0.0
var amplitude_target : float = 0.0
var amplitude_fade_duration : float = 0.0
var amplitude_fade_elapsed : float = 0.0

func polyvoice_on(fade : bool, fade_duration : float = 0.0):
	active = true
	for voice in voices:
		voice.active = true
	
	if not fade: return
	amplitude_start = amplitude
	amplitude_target = 1.0
	amplitude_fade_duration = fade_duration
	amplitude_fade_elapsed = 0.0

func polyvoice_off(fade : bool, fade_duration : float = 0.0):
	active = false
	for voice in voices:
		voice.active = false
	
	if not fade: return
	amplitude_start = amplitude
	amplitude_target = 0.0
	amplitude_fade_duration = fade_duration
	amplitude_fade_elapsed = 0.0

func process(delta: float) -> float:
	if amplitude_fade_elapsed < amplitude_fade_duration:
		amplitude_fade_elapsed += delta;
		var t : float = clampf(amplitude_fade_elapsed / amplitude_fade_duration, 0.0, 1.0);
		amplitude = lerp(amplitude_start, amplitude_target, t);
	else:
		amplitude = amplitude_target;
	
	var sum : float = 0.0
	
	for voice in voices:
		var value = voice.process(delta)
		sum += value
	
	return (sum / sqrt(voices.size())) * 0.2 * amplitude
