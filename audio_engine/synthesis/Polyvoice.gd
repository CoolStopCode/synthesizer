class_name Polyvoice
extends RefCounted

var voices : Array[NewVoice]

func voice_on() -> void:
	for voice in voices:
		voice.voice_on()

func voice_off() -> void:
	for voice in voices:
		voice.voice_off()

func process(delta: float) -> float:
	var sum : float = 0.0
	
	for voice in voices:
		sum += voice.process(delta)
	
	return sum
