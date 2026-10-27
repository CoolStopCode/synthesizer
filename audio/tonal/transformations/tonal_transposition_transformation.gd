class_name TonalTranspositionTransformation
extends TonalTransformation

enum Action {
	MOVE,
	DUPLICATE
}

@export var semitones : int
@export var action : Action

func apply(chord : TonalChord) -> void:
	if action == Action.MOVE:
		for semitone in chord.semitones:
			semitone.transpose(semitones)
	elif action == Action.DUPLICATE:
		var duplicates : Array[TonalSemitone] = []

		for semitone in chord.semitones:
			var new := TonalSemitone.new()
			new.semitone = semitone.semitone + semitones
			duplicates.append(new)

		chord.semitones.append_array(duplicates)
