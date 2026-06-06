class_name Oscillator
extends Generator

var waveform: Waveform
var phase: float = 0.0

var frequency: Parameter
var gain: Parameter

func _init() -> void:
	waveform = Waveform.new()
	frequency = Parameter.new(440.0)
	gain = Parameter.new(1.0)

func process(delta: float) -> float:
	var value := waveform.evaluate(phase)

	phase += frequency.value * delta
	phase = fmod(phase, 1.0)

	return value * gain.value
