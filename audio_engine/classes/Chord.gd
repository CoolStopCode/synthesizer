class_name Chord

var root: int # Note
var octave: int = 4
var type: int # ChordType

var voices: Array[Voice]


const CHORD_INTERVALS = {
	ChordType.MAJOR: [0, 4, 7],
	ChordType.MINOR: [0, 3, 7],
	ChordType.DIMINISHED: [0, 3, 6],
	ChordType.MAJOR_7: [0, 4, 7, 11],
	ChordType.MINOR_7: [0, 3, 7, 10],
	ChordType.DOMINANT_7: [0, 4, 7, 10],
}

func build_voices():
	voices.clear()
	for interval in CHORD_INTERVALS[type]:
		var note_value = root + interval
		var voice = Voice.new()
		voice.frequency = Note.to_frequency(note_value % 12, octave + int((root + interval) / 12))
		voice.waveform = Waveform.SINE
		voices.append(voice)
