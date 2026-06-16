class_name VoiceBuilder

static func chord_to_polyvoice(
	chord : Chord,
) -> Polyvoice:
	var polyvoice := Polyvoice.new()
	polyvoice.voices = []
	
	var notes := chord.get_notes()
	for note : Note in notes:
		var new_voice := Voice.new()
		# Connection slots
		const SLOT_FREQUENCY = 0
		const SLOT_GATE      = 1
		const SLOT_SAMPLE    = 2
		const SLOT_OSC_OUT   = 3
		const SLOT_ENV_OUT   = 4
		const SLOT_MUL_OUT   = 5

		# State offsets
		const STATE_OSC_PHASE = 0
		const STATE_ENV_LEVEL = 1
		const STATE_ENV_STAGE = 2

		# Parameter offsets
		const PARAM_OSC_WAVEFORM = 0
		const PARAM_ENV_A        = 1
		const PARAM_ENV_D        = 2
		const PARAM_ENV_S        = 3
		const PARAM_ENV_R        = 4
		const PARAM_MUL_OP       = 5

		new_voice.set_graph(
			PackedByteArray([  0,             1,            2,            3,            4          ]), # types
			PackedInt32Array([ SLOT_FREQUENCY, SLOT_FREQUENCY, SLOT_GATE,  SLOT_OSC_OUT, SLOT_MUL_OUT ]), # input offsets
			PackedInt32Array([ 2,             1,            1,            2,            1          ]), # input counts
			PackedInt32Array([ SLOT_FREQUENCY, SLOT_OSC_OUT, SLOT_ENV_OUT, SLOT_MUL_OUT, 0         ]), # output offsets
			PackedInt32Array([ 2,             1,            1,            1,            0          ]), # output counts
			PackedInt32Array([ 0,             STATE_OSC_PHASE, STATE_ENV_LEVEL, 0,       0         ]), # state offsets
			PackedInt32Array([ 0,             1,            2,            0,            0          ]), # state counts
			PackedInt32Array([ 0,             PARAM_OSC_WAVEFORM, PARAM_ENV_A, PARAM_MUL_OP, 0    ]), # parameter offsets
			PackedInt32Array([ 0,             1,            4,            1,            0          ]), # parameter counts
			PackedFloat64Array([
				2.0,   # PARAM_OSC_WAVEFORM (SINE)
				0.01,   # PARAM_ENV_A
				5.0,   # PARAM_ENV_D
				0.0,   # PARAM_ENV_S
				0.3,   # PARAM_ENV_R
				2.0,   # PARAM_MUL_OP (MULTIPLY)
			])
		)
		new_voice.frequency = note.to_frequency()
		new_voice.active = false
		polyvoice.voices.append(new_voice)
	
	return polyvoice

static func chords_to_polyvoices(
	chords : Array[Chord],
) -> Array[Polyvoice]:
	
	var polyvoices : Array[Polyvoice]
	for chord in chords:
		polyvoices.append(chord_to_polyvoice(chord))
	return polyvoices
