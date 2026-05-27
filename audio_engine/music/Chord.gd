class_name Chord

var root: Note
var type: Quality.Enum

func get_notes() -> Array[Note]:
	var notes : Array[Note]
	for interval in Quality.INTERVALS[type]:
		var note_midi = (root.to_midi() + interval)
		notes.append(Note.from_midi(note_midi))
	
	return notes
