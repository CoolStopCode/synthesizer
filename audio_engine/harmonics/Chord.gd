class_name Chord
extends Resource

@export var root: Note
@export var quality: Quality

func get_notes() -> Array[Note]:
	var notes : Array[Note]

	for interval in quality.to_intervals():
		var note_midi = (root.to_midi() + interval)
		notes.append(Note.from_midi(note_midi))
	
	return notes
