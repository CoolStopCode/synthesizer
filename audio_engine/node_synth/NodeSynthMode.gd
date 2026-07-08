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
@export var fade_duration : float = 0.05
@export var chord_bend_duration : float = 0.1
@export var layout : Node_Layout

func process(delta : float) -> float:
	return Node_VoiceManager.process_mix(delta)

func build(chords : Array[Chord]) -> void:
	var polyvoices := Node_VoiceBuilder.layout_to_polyvoices(layout, polyvoice_count, voice_count)
	Node_VoiceManager.polyvoices = polyvoices
	Node_VoiceManager.allocation = allocation as Node_VoiceManager.Allocation

var joystick_direction := Vector2.ZERO

func key_pressed(index: int) -> void:
	Node_VoiceManager.polyvoice_on(index, fade_duration)
	var chord := build_chord(index, joystick_direction)
	Node_VoiceManager.bend_polyvoice(Node_VoiceManager.polyvoices[index], chord, 0.0)

func key_released(index: int) -> void:
	Node_VoiceManager.polyvoice_off(index)

func joystick_moved(direction: Vector2) -> void:
	joystick_direction = direction
	var scale : Scale = AudioEngine.key.build_scale()
	var i := 0
	for polyvoice in Node_VoiceManager.polyvoices:
		if polyvoice.active:
			Node_VoiceManager.bend_polyvoice(polyvoice, build_chord(i, direction), chord_bend_duration)
		i += 1

func build_chord(index: int, direction: Vector2) -> Chord:
	var scale : Scale = AudioEngine.key.build_scale()
	match direction:
		Vector2( 0, -1): return scale.triad(index).shift_octave(1)   # up
		Vector2( 0,  0): return scale.triad(index)                   # none
		Vector2( 0,  1): return scale.triad(index).shift_octave(-1)  # down
		
		Vector2(-1, -1): return scale.triad_parallel(index)        # left-up
		Vector2(-1,  0): return scale.root_note(index)               # left
		Vector2(-1,  1): return scale.cinimatic(index)                 # left-down
		
		Vector2( 1, -1): return scale.sixth(index)                   # right-up
		Vector2( 1,  0): return scale.seventh(index)                 # right
		Vector2( 1,  1): return scale.triad(index).invert(1, 1)       # right-down
		_:            return scale.triad(index)
