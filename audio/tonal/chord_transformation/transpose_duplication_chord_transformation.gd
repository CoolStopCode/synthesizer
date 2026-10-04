class_name TonalAudioTransposeDuplicationChordTransformation
extends TonalAudioChordTransformation

@export var semitones : int = 12

func apply(chord : TonalAudioChord) -> void:
	var duplicates : Array[TonalAudioSemitone] = []

	for semitone in chord.semitones:
		var new := TonalAudioSemitone.new()
		new.semitone = semitone.semitone + semitones
		duplicates.append(new)

	chord.semitones.append_array(duplicates)
