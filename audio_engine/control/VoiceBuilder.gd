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
	for i in range(notes.size()):
		if voice_properties.note_enable[i]:
			var note := Note.new(notes[i].note, notes[i].octave + voice_properties.note_octave[i])
			var frequency := note.to_frequency()
			voice.oscillators.append(
				Oscillator.new(
					voice_properties.waveforms[i],
					frequency,
					voice_properties.note_gain[i]
				)
			)
		
		if voice_properties.layer_enable[i]:
			var note := Note.new(notes[i].note, notes[i].octave + voice_properties.layer_octave[i])
			var frequency := note.to_frequency()
			voice.oscillators.append(
				Oscillator.new(
					voice_properties.waveforms[i],
					frequency,
					voice_properties.layer_gain[i]
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
