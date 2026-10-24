class_name CompositionNote
extends Resource

enum NoteEnum {
	C,
	Cs,
	D,
	Ds,
	E,
	F,
	Fs,
	G,
	Gs,
	A,
	As ,
	B
}

@export var note : NoteEnum
@export var octave : int

func _init(_note : NoteEnum = NoteEnum.C, _octave : int = 4) -> void:
	note = _note
	octave = _octave

func to_semitone() -> TonalSemitone:
	return TonalSemitone.new(octave * 12 + note)
