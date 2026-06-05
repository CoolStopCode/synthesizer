class_name Voice

var oscillators : Array[Oscillator]
var envelope : Envelope

var is_pressed : bool = false

func _init(
	_oscillators : Array[Oscillator], 
	_envelope : Envelope, 
) -> void:
	oscillators = _oscillators
	envelope = _envelope

func set_oscillators(
	_oscillators : Array[Oscillator]
) -> void:
	oscillators = _oscillators

func voice_on() -> void:
	is_pressed = true
	envelope.state = Envelope.State.ATTACK

func voice_off() -> void:
	is_pressed = false
	envelope.state = Envelope.State.RELEASE

func process(delta: float) -> float:
	if envelope.state == Envelope.State.IDLE:
		return 0.0
	
	var amp := envelope.process(delta, is_pressed)
	var mixed_sample := 0.0
	
	for i in range(oscillators.size()):
		var oscillator := oscillators[i]
		mixed_sample += oscillator.process(delta)
	return (mixed_sample / oscillators.size()) * amp;
