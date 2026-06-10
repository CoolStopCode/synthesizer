class_name OscillatorModule
extends Module

@export_category("SETTINGS")
@export var waveform : Curve

@export_category("PORTS")
@export var enabled_in: BoolPort
@export var frequency_in: FloatPort
@export var output_out: FloatPort

# PRIVATE
var phase : float = 0.0

func _init():
	inputs = [
		enabled_in,
		frequency_in
	]
	outputs = [output_out]

func process(delta : float) -> void:
	#if not enabled_in.get_value():
		#return
	
	var output : float = waveform.sample(phase)
	
	phase += frequency_in.value * delta
	phase = fmod(phase, 1.0)
	
	output_out.value = output
