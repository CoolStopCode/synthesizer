class_name VoiceBuilder

static func chord_to_voice(
	chord : Chord,
	envelope : Envelope,
	waveform : Waveform.Enum
) -> Voice:
	var voice := Voice.new()
	voice.envelope = envelope.duplicate()
	voice.oscillators = []
	for note in chord.get_notes():
		var oscillator := Oscillator.new(waveform, note.to_frequency())
		voice.oscillators.append(oscillator)
	return voice

static func chords_to_voices(
	chords : Array[Chord],
	envelope : Envelope,
	waveform : Waveform.Enum
) -> Array[Voice]:
	var voices : Array[Voice]
	for chord in chords:
		voices.append(chord_to_voice(chord, envelope, waveform))
	return voices
