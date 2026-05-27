class_name VoiceManager
extends Node

@export var chords: int = 7

var voice_pool: Array[Voice] = []

func build_voice_pool(_voice_pool : Array[Voice]):
	voice_pool = _voice_pool

func voice_on(index : int):
	voice_pool[index].chord_on()

func voice_off(index : int):
	voice_pool[index].chord_off()

func process_mix(delta : float) -> float:
	var mixed_sample := 0.0
	for voice in voice_pool:
		mixed_sample += voice.process(delta)
	
	return clampf(mixed_sample, -1.0, 1.0)
