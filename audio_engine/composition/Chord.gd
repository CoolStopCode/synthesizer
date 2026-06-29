class_name Chord
extends Resource

var notes : Array[Semitone]

func _init(_notes : Array[Semitone] = []) -> void:
	notes = _notes

func append_note(note : Semitone) -> void:
	notes.append(note)
