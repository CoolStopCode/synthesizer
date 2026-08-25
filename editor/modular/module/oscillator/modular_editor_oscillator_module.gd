class_name ModularEditorOscillatorModule
extends ModularEditorModule

enum Waveform {
	SINE,
	SQUARE,
	SAW,
	TRIANGLE
}

@export var waveform : Waveform

@export var waveform_button : InterfaceButton
@export var frequency_port : ModularEditorInputPort
@export var sample_port : ModularEditorOutputPort

@export var waveform_textures : Dictionary[Waveform, Texture]

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

func _ready() -> void:
	waveform_button.icon = waveform_textures[waveform]
	waveform_button.update_visuals()

func _on_waveform_button_pressed() -> void:
	waveform = (waveform + 1) % Waveform.size() as Waveform
	
	waveform_button.icon = waveform_textures[waveform]
	waveform_button.update_visuals()
