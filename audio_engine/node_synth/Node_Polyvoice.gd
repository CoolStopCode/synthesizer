class_name Node_Polyvoice
extends RefCounted

var voices : Array[Node_Voice]
var active : bool = false

func voice_on() -> void:
	active = true
	for voice in voices:
		voice.active = true

func voice_off() -> void:
	active = false
	for voice in voices:
		voice.active = false

func process(delta: float) -> float:
	var sum : float = 0.0
	
	for voice in voices:
		var value = voice.process(delta)
		sum += value
	
	
	return (sum / sqrt(voices.size())) * 0.2
