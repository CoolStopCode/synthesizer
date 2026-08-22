class_name ModularAudioLayout
extends Resource

@export var types : PackedByteArray
@export var module_offsets : PackedInt32Array
@export var output_offsets : PackedInt32Array
@export var output_routes : PackedInt32Array
@export var memory_data : PackedFloat64Array

func to_voice() -> ModularAudioVoice:
	var voice := ModularAudioVoice.new()
	
	voice.set_layout(
		types,
		module_offsets,
		output_offsets,
		output_routes,
		memory_data
	)
	
	return voice

func to_polyvoice(
	voice_count : int
) -> ModularAudioPolyvoice:
	var polyvoice := ModularAudioPolyvoice.new()
	polyvoice.voices = []
	
	for i in range(voice_count):
		var voice : ModularAudioVoice = to_voice()
		polyvoice.voices.append(voice)
	
	return polyvoice

func to_polyvoices(
	polyvoice_count : int,
	voice_count : int
) -> Array[ModularAudioPolyvoice]:
	var polyvoices : Array[ModularAudioPolyvoice]
	for i in range(polyvoice_count):
		polyvoices.append(to_polyvoice(voice_count))
	return polyvoices
