class_name Voice

var oscillator: Oscillator
var envelope: Envelope

var is_pressed: bool = false
var note_id: int = -1

func _init(_oscillator : Oscillator, _envelope : Envelope) -> void:
	oscillator = _oscillator
	envelope = _envelope

func note_on() -> void:
	is_pressed = true
	envelope.process(0, is_pressed)

func note_off() -> void:
	is_pressed = false

func process(delta: float) -> float:
	if envelope.state == Envelope.State.IDLE:
		return 0.0
	
	var amp := envelope.process(delta, is_pressed)
	var sample := oscillator.process(delta)
	
	return sample * amp
