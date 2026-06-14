class_name OscillatorModule
extends Module

enum Waveform {
	SINE,
	SQUARE,
	SAW,
	TRIANGLE,
	CUSTOM
}

@export_category("SETTINGS")
@export var waveform : Waveform
@export var curve : Curve

@export_category("PORTS")
@export var IN_enabled: BoolPort
@export var IN_frequency: FloatPort
@export var OUT_output: FloatPort

# PRIVATE
var phase : float = 0.0

func _init():
	inputs = [
		IN_enabled,
		IN_frequency
	]
	outputs = [
		OUT_output
	]

func process(delta : float) -> void:
	#if not enabled_in.get_value():
		#return
	
	phase += IN_frequency.value * delta
	phase = fmod(phase, 1.0)
	
	var output : float = evaluate()

	OUT_output.value = output

func evaluate() -> float:
	var amplitude : float
	match waveform:
		Waveform.SINE:
			amplitude = sin(phase * TAU)
		Waveform.SQUARE:
			amplitude = 1.0 if phase < 0.5 else -1.0
		Waveform.SAW:
			amplitude = (phase * 2.0) - 1.0
		Waveform.TRIANGLE:
			amplitude =  1.0 - 4.0 * abs(phase - 0.5)
		Waveform.CUSTOM:
			amplitude = curve.sample(phase)
		_:
			amplitude = 0.0
	return amplitude
