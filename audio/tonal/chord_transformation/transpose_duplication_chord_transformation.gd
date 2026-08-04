class_name TransposeDuplicationChordTransformation
extends ChordTransformation

@export var semitones : int = 12

func apply(chord : Chord) -> void:
	var duplicates : Array[Semitone] = []

	for semitone in chord.semitones:
		var new := Semitone.new()
		new.semitone = semitone.semitone + semitones
		duplicates.append(new)

	chord.semitones.append_array(duplicates)
