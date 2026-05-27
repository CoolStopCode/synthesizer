class_name Note
extends Resource

enum Enum {
	C = 0,
	Cs = 1,
	D = 2,
	Ds = 3,
	E = 4,
	F = 5,
	Fs = 6,
	G = 7,
	Gs = 8,
	A = 9,
	As = 10,
	B = 11
}

@export var note : Note.Enum
@export var octave : int

func _init(_note : Note.Enum = Note.Enum.C, _octave : int = 4) -> void:
	note = _note
	octave = _octave

func to_midi() -> int:
	return note + octave * 12

func to_string_name() -> String:
	return str(Enum.keys()[note].replace("s", "#")) + str(octave)

static func from_midi(_midi : int) -> Note:
	return Note.new(_midi % 12, (_midi / 12) - 1)

func to_frequency() -> float:
	var midi := to_midi()
	const A4 := 440.0
	return A4 * pow(2.0, (midi - 69) / 12.0)
