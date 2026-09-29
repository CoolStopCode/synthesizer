class_name TonalAudioInversionChordTransformation
extends TonalAudioChordTransformation

enum Direction {
	UP,
	DOWN
}

@export var amount : int
@export var direction : Direction

func apply(chord : TonalAudioChord):
	for i in range(amount):
		if direction == Direction.UP:
			var lowest : TonalAudioSemitone = chord.semitones.front()
			lowest.shift_octave(1)
		elif direction == Direction.DOWN:
			var highest : TonalAudioSemitone = chord.semitones.back()
			highest.shift_octave(-1)
