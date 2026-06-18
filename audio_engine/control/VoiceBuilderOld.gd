class_name VoiceBuilderOld

static func chord_to_polyvoice(
	chord : Chord,
	graph : VoiceGraph
) -> Polyvoice:
	var polyvoice := Polyvoice.new()
	polyvoice.voices = []
	
	var notes := chord.get_notes()
	for note : Note in [notes[0]]:
		var new_voice := VoiceBuilder.graph_to_voice(graph)
		
		new_voice.frequency = note.to_frequency()
		new_voice.active = false
		polyvoice.voices.append(new_voice)
	
	return polyvoice

static func chords_to_polyvoices(
	chords : Array[Chord],
	graph : VoiceGraph,
) -> Array[Polyvoice]:
	
	var polyvoices : Array[Polyvoice]
	for chord in chords:
		polyvoices.append(chord_to_polyvoice(chord, graph))
	return polyvoices
