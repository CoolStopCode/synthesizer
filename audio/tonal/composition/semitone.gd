class_name Semitone
extends RefCounted

var semitone : int

func _init(_semitone : int = 69) -> void:
	semitone = _semitone

func to_frequency() -> float:
	return 440.0 * pow(2.0, (semitone - 69) / 12.0)

const NOTE_NAMES := ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

func to_string_name() -> String:
	return NOTE_NAMES[semitone % 12] + str(semitone / 12)

func shift_octave(octave : int) -> Semitone:
	semitone += 12 * octave
	return self

func transpose(amount : int) -> Semitone:
	semitone += amount
	return self
