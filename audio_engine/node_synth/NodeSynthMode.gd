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
	Node_VoiceManager.polyvoices = polyvoices
	Node_VoiceManager.allocation = allocation as Node_VoiceManager.Allocation

func key_pressed(index: int) -> void:
	Node_VoiceManager.polyvoice_on(index)
	var scale : Scale = AudioEngine.key.build_scale()
		
	var chord : Chord
		
	match dir:
		Vector2(0, 0):
			chord = scale.triad(index)
		Vector2(0, 1):
			chord = scale.root_note(index)
		_:
			chord = scale.sus2(index)
		
	Node_VoiceManager.modify_polyvoice_chord(Node_VoiceManager.polyvoices[index], chord)

func key_released(index: int) -> void:
	Node_VoiceManager.polyvoice_off(index)

var dir : Vector2

func joystick_moved(direction : Vector2) -> void:
	dir = direction
	var scale : Scale = AudioEngine.key.build_scale()
	
	var i : int = -1
	for polyvoice in Node_VoiceManager.polyvoices:
		i += 1
		if not polyvoice.active: continue
		
		var chord : Chord
		
		match direction:
			Vector2(0, 0):
				chord = scale.triad(i)
			Vector2(0, 1):
				chord = scale.root_note(i)
			_:
				chord = scale.sus2(i)
		
		Node_VoiceManager.modify_polyvoice_chord(polyvoice, chord)
