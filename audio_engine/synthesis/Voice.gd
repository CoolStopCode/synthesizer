class_name Voice

var oscillators: Array[Oscillator]
var envelope: Envelope

var is_pressed: bool = false

func _init(_oscillators : Array[Oscillator] = [], _envelope : Envelope = null) -> void:
	oscillators = _oscillators
	envelope = _envelope

func voice_on() -> void:
	is_pressed = true
	envelope.process(0, is_pressed)

func voice_off() -> void:
	is_pressed = false
	envelope.process(0, is_pressed)

func process(delta: float) -> float:
	if envelope.state == Envelope.State.IDLE:
		return 0.0
	
	var amp := envelope.process(delta, is_pressed)
	var mixed_sample := 0.0
	for oscillator in oscillators:
		mixed_sample += oscillator.process(delta)
	
	return mixed_sample * amp / oscillators.size()
