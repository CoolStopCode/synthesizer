class_name VoiceManager
extends Node

@export var chords: int = 7

var voice_pool: Array[Voice] = []

func set_voice_pool(_voice_pool : Array[Voice]):
	voice_pool = _voice_pool

func set_voice_oscillators(index : int, oscillators : Array[Oscillator]):
	voice_pool[index].set_oscillators(oscillators)

func voice_on(index : int):
	voice_pool[index].voice_on()

func voice_off(index : int):
	voice_pool[index].voice_off()

func process_mix(delta : float) -> float:
	var mixed_sample := 0.0
	for voice in voice_pool:
		mixed_sample += voice.process(delta)
	
	return mixed_sample
