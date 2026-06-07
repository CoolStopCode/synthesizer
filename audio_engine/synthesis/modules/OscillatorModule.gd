class_name OscillatorModule
extends Module

# SETTINGS
var waveform : Curve

# PORTS
var enabled_in: BoolPortIn
var frequency_in: FloatPortIn
var output_out: FloatPortOut

# PRIVATE
var phase : float = 0.0

func _init():
	enabled_in = BoolPortIn.new()
	frequency_in = FloatPortIn.new()
	output_out = FloatPortOut.new()

	inputs = [enabled_in, frequency_in]
	outputs = [output_out]

func process(delta : float) -> void:
	var output : float = waveform.sample(phase)
	
	phase += frequency_in.get_value() * delta
	phase = fmod(phase, 1.0)

	output_out.set_value(output)
