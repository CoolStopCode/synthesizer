class_name Voice

var frequency : float
var waveform : int = Waveform.SINE
var phase : float = 0.0
var volume : float = 1.0

#func _init(freq : float):
	#frequency = freq

func evaluate() -> float:
	return Oscillator.evaluate(waveform, phase)
