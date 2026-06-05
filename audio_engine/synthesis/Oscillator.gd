class_name Oscillator

var waveform : Waveform
var phase : float = 0.0
var frequency : float
var gain : float

func _init(
	_waveform : Waveform = Waveform.new(),
	_frequency : float = 440.0,
	_gain : float = 1.0
) -> void:
	waveform = _waveform
	frequency = _frequency
	gain = _gain

func process(delta : float) -> float:
	var value := waveform.evaluate(phase)

	# advance phase
	phase += frequency * delta
	phase = fmod(phase, 1.0)
	
	return value * gain
