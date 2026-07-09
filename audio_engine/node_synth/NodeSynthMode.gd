class_name NodeSynthMode
extends AudioMode

enum Allocation {
	POLY,
	MONO,
	LEGATO
}

var scale : Scale
var voice_manager : Node_VoiceManager

@export var polyvoice_count: int = 7
@export var voice_count: int = 5
@export var allocation: Allocation
@export var fade_duration : float = 0.05
@export var chord_bend_duration : float = 0.1
@export var layout : Node_Layout

func process(delta : float) -> float:
	return voice_manager.process_mix(delta)

func build(_scale : Scale) -> void:
	scale = _scale
	voice_manager = Node_VoiceManager.new()
	voice_manager.polyvoices = layout.to_polyvoices(polyvoice_count, voice_count)
	voice_manager.allocation = allocation as Node_VoiceManager.Allocation

func key_pressed(index: int) -> void:
	voice_manager.polyvoice_on(index, fade_duration)
	var chord := build_chord(index, joystick_direction)
	voice_manager.bend_polyvoice(voice_manager.polyvoices[index], chord, 0.0)

func key_released(index: int) -> void:
	voice_manager.polyvoice_off(index)

func joystick_moved() -> void:
	var i := 0
	for polyvoice in voice_manager.polyvoices:
		if polyvoice.active:
			voice_manager.bend_polyvoice(polyvoice, build_chord(i, joystick_direction), chord_bend_duration)
		i += 1

func build_chord(index: int, direction: Vector2) -> Chord:
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
