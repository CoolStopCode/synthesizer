class_name Voice
extends RefCounted

var modulators: Array[Modulator] = []
var parameters: Array[Parameter] = []
var generators: Array[Generator] = []

var is_pressed : bool = false

func voice_on() -> void:
	for modulator in modulators:
		modulator.voice_on()

func voice_off() -> void:
	for modulator in modulators:
		modulator.voice_off()

func process(delta: float) -> float:
	var mixed_sample := 0.0
	
	for modulator in modulators:
		modulator.process(delta)
	for parameter in parameters:
		parameter.process(delta)
	for generator in generators:
		mixed_sample += generator.process(delta)
	
	
	return mixed_sample / generators.size();
