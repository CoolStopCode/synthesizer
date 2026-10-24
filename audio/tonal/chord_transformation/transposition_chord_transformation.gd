class_name TonalTranspositionChordTransformation
extends TonalChordTransformation

@export var semitones : int = 0

func apply(chord : TonalChord) -> void:
	for semitone in chord.semitones:
		semitone.transpose(semitones)
