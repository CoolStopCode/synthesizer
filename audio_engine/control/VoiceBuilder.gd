class_name VoiceBuilder

static func chord_to_polyvoice(
	chord : Chord,
	voice : Voice
) -> Polyvoice:
	var polyvoice := Polyvoice.new()
	polyvoice.voices = []
	
	var notes := chord.get_notes()
	for note in notes:
		var new_voice : Voice = voice.duplicate(true)
		new_voice.input_module.frequency = note.to_frequency()
		polyvoice.voices.append(new_voice)
	
	return polyvoice

static func chords_to_polyvoices(
	chords : Array[Chord],
	voice : Voice
) -> Array[Polyvoice]:
	
	var polyvoices : Array[Polyvoice]
	for chord in chords:
		polyvoices.append(chord_to_polyvoice(chord, voice))
	return polyvoices
