class_name VoiceBuilder

static func chord_to_voice(
	chord : Chord,
	envelope : Envelope,
	voice_properties : VoiceProperties
) -> Voice:
	var voice := Voice.new([], null, null)
	voice.oscillators = []
	voice.envelope = envelope.duplicate()
	voice.voice_properties = voice_properties
	
	var notes := chord.get_notes()
	for i : int in range(voice_properties.oscillator_layers.size()):
		var note_layer : OscillatorLayer = voice_properties.oscillator_layers[i]
		var from_note : Note = notes[note_layer.chord_note]
		if    note_layer.enabled and\
			  note_layer.chord_note < notes.size() and\
			  from_note.octave + note_layer.octave_shift >= 0:
			var to_note := Note.new(from_note.note + note_layer.semitone_shift, from_note.octave + note_layer.octave_shift)
			var frequency := to_note.to_frequency()
			voice.oscillators.append(
				Oscillator.new(
					note_layer.waveform,
					frequency,
					note_layer.gain
				)
			)
	return voice

static func chords_to_voices(
	chords : Array[Chord],
	envelope : Envelope,
	voice_properties : VoiceProperties
) -> Array[Voice]:
	var voices : Array[Voice]
	for chord in chords:
		voices.append(chord_to_voice(chord, envelope, voice_properties))
	return voices
