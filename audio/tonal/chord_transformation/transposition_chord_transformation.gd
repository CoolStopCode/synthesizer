class_name TonalAudioTranspositionChordTransformation
extends TonalAudioChordTransformation

@export var semitones : int = 0

func apply(chord : TonalAudioChord) -> void:
	for semitone in chord.semitones:
		semitone.transpose(semitones)
