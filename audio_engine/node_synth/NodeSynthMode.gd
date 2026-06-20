class_name NodeSynthMode
extends AudioMode

@export var polyvoice_count: int = 7
@export var mono : bool
@export var layout : Node_Layout

func process(delta : float) -> float:
	return Node_VoiceManager.process_mix(delta)

func build(chords : Array[Chord]) -> void:
	var polyvoices := Node_VoiceBuilder.chords_to_polyvoices(chords, layout)
	Node_VoiceManager.set_polyvoices(polyvoices)

func key_pressed(index: int) -> void:
	Node_VoiceManager.polyvoices_off()
	Node_VoiceManager.polyvoice_on(index)

func key_released(index: int) -> void:
	Node_VoiceManager.polyvoice_off(index)
