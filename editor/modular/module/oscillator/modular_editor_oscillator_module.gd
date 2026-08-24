class_name ModularEditorOscillatorModule
extends ModularEditorModule

enum Waveform {
	SINE,
	SAW,
	SQUARE,
	TRIANGLE
}

@export var waveform : Waveform
@export var frequency_port : ModularEditorInputPort
@export var sample_port : ModularEditorOutputPort

func get_module_data() -> Array[float]:
	return [
		frequency_port.get_value(),
		0.0,
		waveform
	]

func get_input_map() -> Array[ModularEditorInputPort]:
	return [
		frequency_port,
		null,
		null
	]

func get_output_map() -> Array[ModularEditorOutputPort]:
	return [
		sample_port
	]
