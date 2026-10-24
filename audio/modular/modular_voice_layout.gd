class_name ModularVoiceLayout
extends Resource

@export var types : PackedByteArray
@export var module_offsets : PackedInt32Array
@export var output_offsets : PackedInt32Array
@export var output_routes : PackedInt32Array
@export var memory_data : PackedFloat64Array

func to_voice() -> ModularVoice:
	var voice := ModularVoice.new()
	
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
) -> ModularPolyvoice:
	var polyvoice := ModularPolyvoice.new()
	polyvoice.voices = []
	
	for i in range(voice_count):
		var voice : ModularVoice = to_voice()
		polyvoice.voices.append(voice)
	
	return polyvoice

func to_polyvoices(
	polyvoice_count : int,
	voice_count : int
) -> Array[ModularPolyvoice]:
	var polyvoices : Array[ModularPolyvoice]
	for i in range(polyvoice_count):
		polyvoices.append(to_polyvoice(voice_count))
	return polyvoices
