class_name InversionChordTransformation
extends ChordTransformation

enum Direction {
	UP,
	DOWN
}

@export var amount : int
@export var direction : Direction

func apply(chord : Chord):
	for i in range(amount):
		if direction == Direction.UP:
			var lowest : Semitone = chord.semitones.front()
			lowest.shift_octave(1)
		elif direction == Direction.DOWN:
			var highest : Semitone = chord.semitones.back()
			highest.shift_octave(-1)
