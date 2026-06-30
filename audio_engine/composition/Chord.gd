class_name Chord
extends Resource

var semitones : Array[Semitone]

func _init(_semitones : Array[Semitone] = []) -> void:
	semitones = _semitones

func append_semitone(note : Semitone) -> void:
	semitones.append(note)
