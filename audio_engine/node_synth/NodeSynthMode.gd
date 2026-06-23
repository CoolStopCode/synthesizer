class_name NodeSynthMode
extends AudioMode

enum Allocation {
	POLY,
	MONO,
	LEGATO
}

@export var polyvoice_count: int = 7
@export var allocation: Allocation
@export var layout : Node_Layout

func process(delta : float) -> float:
	return Node_VoiceManager.process_mix(delta)

func build(chords : Array[Chord]) -> void:
	var polyvoices := Node_VoiceBuilder.chords_to_polyvoices(chords, layout)
	Node_VoiceManager.set_polyvoices(polyvoices)
	Node_VoiceManager.allocation = allocation as Node_VoiceManager.Allocation

func key_pressed(index: int) -> void:
	Node_VoiceManager.polyvoice_on(index)

func key_released(index: int) -> void:
	Node_VoiceManager.polyvoice_off(index)
