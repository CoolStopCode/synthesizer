class_name Chord

var root: Note
var type: ChordType.Enum

const CHORD_INTERVALS = {
	ChordType.Enum.MAJOR: [0, 4, 7],
	ChordType.Enum.MINOR: [0, 3, 7],
	ChordType.Enum.DIMINISHED: [0, 3, 6],
	ChordType.Enum.MAJOR_7: [0, 4, 7, 11],
	ChordType.Enum.MINOR_7: [0, 3, 7, 10],
	ChordType.Enum.DOMINANT_7: [0, 4, 7, 10],
}

func get_notes() -> Array[Note]:
	var notes : Array[Note]
	for interval in CHORD_INTERVALS[type]:
		var note_midi = (root.to_midi() + interval)
		notes.append(Note.from_midi(note_midi))
	
	return notes
