class_name Polyvoice
extends RefCounted

var voices : Array[Voice]

func voice_on() -> void:
	for voice in voices:
		voice.active = true

func voice_off() -> void:
	for voice in voices:
		voice.active = false

func process(delta: float) -> float:
	var sum : float = 0.0
	
	for voice in voices:
		var value = voice.process(delta)
		sum += value
	
	
	return (sum / sqrt(voices.size())) * 0.2
