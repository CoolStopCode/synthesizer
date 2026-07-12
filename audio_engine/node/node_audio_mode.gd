class_name NodeMode
extends TonalAudioMode

var voice_manager : Node_VoiceManager
@export var layout : Node_Layout

func process(delta : float) -> float:
	return voice_manager.process_mix(delta)

func build() -> void:
	super.build()
	voice_manager = Node_VoiceManager.new()
	voice_manager.polyvoices = layout.to_polyvoices(polyvoice_count, voice_count)
	voice_manager.allocation = allocation as Node_VoiceManager.Allocation

func key_pressed(index: int) -> void:
	voice_manager.polyvoice_on(index, fade_duration)
	var chord := build_chord(index)
	voice_manager.bend_polyvoice(voice_manager.polyvoices[index], chord, 0.0)

func key_released(index: int) -> void:
	voice_manager.polyvoice_off(index)

func bend_changed() -> void:
	var i := 0
	for polyvoice in voice_manager.polyvoices:
		if polyvoice.active:
			voice_manager.bend_polyvoice(polyvoice, build_chord(i), chord_bend_duration)
		i += 1
