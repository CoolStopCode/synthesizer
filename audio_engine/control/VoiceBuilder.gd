class_name VoiceBuilder

static func duplicate_voice(voice : Voice) -> Voice:
	var new_voice := Voice.new()
	new_voice.modules = []
	for module in voice.modules:
		var new_module = module.duplicate()
		if module == voice.input_module:
			new_voice.input_module = new_module
		if module == voice.output_module:
			new_voice.output_module = new_module
		new_voice.modules.append(new_module)
	return new_voice

static func chord_to_polyvoice(
	chord : Chord,
	voice : NewVoice
) -> Polyvoice:
	var polyvoice := Polyvoice.new()
	polyvoice.voices = []
	
	var notes := chord.get_notes()
	for note in notes:
		var new_voice := voice.duplicate(true)
		new_voice.input_frequency = note.to_frequency()
		polyvoice.voices.append(new_voice)
	
	return polyvoice

static func chords_to_polyvoices(
	chords : Array[Chord],
	voice : NewVoice
) -> Array[Polyvoice]:
	
	var polyvoices : Array[Polyvoice]
	for chord in chords:
		polyvoices.append(chord_to_polyvoice(chord, voice))
	return polyvoices
