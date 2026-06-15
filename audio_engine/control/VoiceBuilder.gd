class_name VoiceBuilder

static func chord_to_polyvoice(
	chord : Chord,
	#voice : Voice
) -> Polyvoice:
	var polyvoice := Polyvoice.new()
	polyvoice.voices = []
	
	var notes := chord.get_notes()
	for note : Note in [notes[0]]:
		var new_voice := Voice.new()
		var types              = PackedByteArray()
		var input_offsets      = PackedInt32Array()
		var input_counts       = PackedInt32Array()
		var output_offsets     = PackedInt32Array()
		var output_counts      = PackedInt32Array()
		var state_offsets      = PackedInt32Array()
		var state_counts       = PackedInt32Array()
		var parameter_offsets  = PackedInt32Array()
		var parameter_counts   = PackedInt32Array()
		var parameter_values   = PackedFloat64Array()

		# MODULE TYPES
		const MODULE_INPUT      = 0
		const MODULE_OSC        = 1
		const MODULE_ENVELOPE   = 2
		const MODULE_ARITHMETIC = 3
		const MODULE_OUTPUT     = 4

		# --- INPUT ---
		types.append(MODULE_INPUT)
		input_offsets.append(0);     input_counts.append(2)
		output_offsets.append(0);    output_counts.append(2)
		state_offsets.append(0);     state_counts.append(0)
		parameter_offsets.append(0); parameter_counts.append(0)

		# --- ENVELOPE: gate=slot1, out=slot3, states 0..1, params 0..3 ---
		types.append(MODULE_ENVELOPE)
		input_offsets.append(1);     input_counts.append(1)
		output_offsets.append(3);    output_counts.append(1)
		state_offsets.append(0);     state_counts.append(2)
		parameter_offsets.append(0); parameter_counts.append(4)
		parameter_values.append(0.05)  # attack
		parameter_values.append(0.1)   # decay
		parameter_values.append(0.7)   # sustain
		parameter_values.append(0.3)   # release

		# --- 32 OSCILLATORS: out=slots 4..35, states 2..33, params 4..35 ---
		for i in range(32):
			types.append(MODULE_OSC)
			input_offsets.append(0);         input_counts.append(1)
			output_offsets.append(4 + i);    output_counts.append(1)
			state_offsets.append(2 + i);     state_counts.append(1)
			parameter_offsets.append(4 + i); parameter_counts.append(1)
			parameter_values.append(float(i % 4))

		# --- LEVEL 0: 16 adds, (4,5),(6,7)...(34,35) -> slots 36..51 ---
		for i in range(16):
			types.append(MODULE_ARITHMETIC)
			input_offsets.append(4 + i * 2);  input_counts.append(2)
			output_offsets.append(36 + i);    output_counts.append(1)
			state_offsets.append(0);          state_counts.append(0)
			parameter_offsets.append(0);      parameter_counts.append(0)

		# --- LEVEL 1: 8 adds, (36,37)...(50,51) -> slots 52..59 ---
		for i in range(8):
			types.append(MODULE_ARITHMETIC)
			input_offsets.append(36 + i * 2); input_counts.append(2)
			output_offsets.append(52 + i);    output_counts.append(1)
			state_offsets.append(0);          state_counts.append(0)
			parameter_offsets.append(0);      parameter_counts.append(0)

		# --- LEVEL 2: 4 adds, (52,53)...(58,59) -> slots 60..63 ---
		for i in range(4):
			types.append(MODULE_ARITHMETIC)
			input_offsets.append(52 + i * 2); input_counts.append(2)
			output_offsets.append(60 + i);    output_counts.append(1)
			state_offsets.append(0);          state_counts.append(0)
			parameter_offsets.append(0);      parameter_counts.append(0)

		# --- LEVEL 3: 2 adds, (60,61),(62,63) -> slots 64..65 ---
		for i in range(2):
			types.append(MODULE_ARITHMETIC)
			input_offsets.append(60 + i * 2); input_counts.append(2)
			output_offsets.append(64 + i);    output_counts.append(1)
			state_offsets.append(0);          state_counts.append(0)
			parameter_offsets.append(0);      parameter_counts.append(0)

		# --- LEVEL 4: 1 add, (64,65) -> slot 66 ---
		types.append(MODULE_ARITHMETIC)
		input_offsets.append(64);    input_counts.append(2)
		output_offsets.append(66);   output_counts.append(1)
		state_offsets.append(0);     state_counts.append(0)
		parameter_offsets.append(0); parameter_counts.append(0)

		# --- MULTIPLY: sum(66) * env(3), but need consecutive slots ---
		# Copy envelope out to slot 67 via an add with slot 36 (we don't care about output correctness)
		# Actually just re-route envelope output to slot 67 so (66,67) are adjacent for multiply
		# Patch envelope output offset:
		output_offsets[1] = 67

		# --- MULTIPLY: (66,67) -> slot 68, op=MULTIPLY (param=2.0) ---
		types.append(MODULE_ARITHMETIC)
		input_offsets.append(66);     input_counts.append(2)
		output_offsets.append(68);    output_counts.append(1)
		state_offsets.append(0);      state_counts.append(0)
		parameter_offsets.append(36); parameter_counts.append(1)
		parameter_values.append(2.0)  # MULTIPLY

		# --- OUTPUT: slot 68 -> slot 2 ---
		types.append(MODULE_OUTPUT)
		input_offsets.append(68);    input_counts.append(1)
		output_offsets.append(0);    output_counts.append(0)
		state_offsets.append(0);     state_counts.append(0)
		parameter_offsets.append(0); parameter_counts.append(0)

		new_voice.set_graph(
			types,
			input_offsets,    input_counts,
			output_offsets,   output_counts,
			state_offsets,    state_counts,
			parameter_offsets, parameter_counts,
			parameter_values
		)
		new_voice.frequency = note.to_frequency()
		new_voice.active = false
		polyvoice.voices.append(new_voice)
	
	return polyvoice

static func chords_to_polyvoices(
	chords : Array[Chord],
	#voice : Voice
) -> Array[Polyvoice]:
	
	var polyvoices : Array[Polyvoice]
	for chord in chords:
		polyvoices.append(chord_to_polyvoice(chord))
	return polyvoices
