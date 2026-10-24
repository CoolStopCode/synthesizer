class_name TonalInversionChordTransformation
extends TonalChordTransformation

enum Direction {
	UP,
	DOWN
}

@export var amount : int
@export var direction : Direction

func apply(chord : TonalChord):
	for i in range(amount):
		if direction == Direction.UP:
			var lowest : TonalSemitone = chord.semitones.front()
			lowest.shift_octave(1)
		elif direction == Direction.DOWN:
			var highest : TonalSemitone = chord.semitones.back()
			highest.shift_octave(-1)
