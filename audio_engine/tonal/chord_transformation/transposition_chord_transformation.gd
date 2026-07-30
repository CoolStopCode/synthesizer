class_name TranspositionChordTransformation
extends ChordTransformation

@export var semitones : int = 0

func apply(chord : Chord) -> void:
	for semitone in chord.semitones:
		semitone.transpose(semitones)
