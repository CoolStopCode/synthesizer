class_name NodeSynthMode
extends AudioMode

enum Allocation {
	POLY,
	MONO,
	LEGATO
}

@export var polyvoice_count: int = 7
@export var voice_count: int = 5
@export var allocation: Allocation
@export var layout : Node_Layout

func process(delta : float) -> float:
	return Node_VoiceManager.process_mix(delta)

func build(chords : Array[Chord]) -> void:
	var polyvoices := Node_VoiceBuilder.layout_to_polyvoices(layout, polyvoice_count, voice_count)
	Node_VoiceManager.polyvoices = polyvoices
	Node_VoiceManager.allocation = allocation as Node_VoiceManager.Allocation

var joystick_direction := Vector2.ZERO

func key_pressed(index: int) -> void:
	Node_VoiceManager.polyvoice_on(index)
	var chord := build_chord(index, joystick_direction)
	Node_VoiceManager.modify_polyvoice_chord(Node_VoiceManager.polyvoices[index], chord)

func key_released(index: int) -> void:
	Node_VoiceManager.polyvoice_off(index)

func joystick_moved(direction: Vector2) -> void:
	joystick_direction = direction
	var scale : Scale = AudioEngine.key.build_scale()
	var i := 0
	for polyvoice in Node_VoiceManager.polyvoices:
		if polyvoice.active:
			Node_VoiceManager.modify_polyvoice_chord(polyvoice, build_chord(i, direction))
		i += 1

func build_chord(index: int, direction: Vector2) -> Chord:
	var scale : Scale = AudioEngine.key.build_scale()
	match direction:
		Vector2( 0,  0): return scale.triad(index)
		Vector2( 0,  1): return scale.root_note(index)
		Vector2( 0, -1): return scale.ninth(index)
		Vector2( 1,  1): return scale.triad_flip_third(index)
		_:            return scale.sus2(index)
