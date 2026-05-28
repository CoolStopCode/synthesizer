class_name Oscillator

var waveform : Waveform.Enum
var phase : float = 0.0
var frequency : float
var gain : float

func _init(
	_waveform : Waveform.Enum = Waveform.Enum.SAW, 
	_frequency : float = 440.0,
	_gain : float = 1.0
) -> void:
	waveform = _waveform
	frequency = _frequency
	gain = _gain

func process(delta : float) -> float:
	var value := evaluate(phase)

	# advance phase
	phase += frequency * delta
	phase = fmod(phase, 1.0)
	
	return value * gain


func evaluate(p: float) -> float:
	match waveform:
		Waveform.Enum.SINE:
			return sin(p * TAU)

		Waveform.Enum.SQUARE:
			return 1.0 if p < 0.5 else -1.0

		Waveform.Enum.SAW:
			return (p * 2.0) - 1.0

		Waveform.Enum.TRIANGLE:
			return 1.0 - 4.0 * abs(p - 0.5)
		
		_:
			
			return 0.0
