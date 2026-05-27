class_name VoiceBuilder

static func chord_to_voice(chord : Chord) -> Voice:
	var voice := Voice.new()
	voice.envelope = Envelope.new(0.01, 2.0, 0.0, 0.01, 0.1)
	voice.oscillators = []
	for note in chord.get_notes():
		var oscillator := Oscillator.new(Waveform.Enum.SQUARE, note.to_frequency())
		voice.oscillators.append(oscillator)
	return voice

static func chords_to_voices(chords : Array[Chord]) -> Array[Voice]:
	var voices : Array[Voice]
	for chord in chords:
		voices.append(chord_to_voice(chord))
	return voices
