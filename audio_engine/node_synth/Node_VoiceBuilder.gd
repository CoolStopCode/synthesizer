class_name Node_VoiceBuilder

static func layout_to_voice(layout : Node_Layout) -> Node_Voice:
	var voice := Node_Voice.new()
	
	var types : PackedByteArray
	
	var input_offsets : PackedInt32Array
	var output_offsets : PackedInt32Array
	var state_offsets : PackedInt32Array
	var parameter_offsets : PackedInt32Array
	
	var input_routes : PackedInt32Array
	var initial_memory_data : PackedFloat64Array
	initial_memory_data.append_array([0.0, 0.0, 0.0, 0.0])
	
	for module in layout.modules:
		var type := module.get_type()
		if type == -1: # Constant Module
			continue
		
		var module_states := module.get_states()
		var module_parameters := module.get_parameters()
		
		types.append(type)
		
		# STATES
		var state_data: Array[float] = module.get_states()
		var state_count := state_data.size()
		state_offsets.append(initial_memory_data.size())
		initial_memory_data.append_array(state_data)
		
		# PARAMETERS
		var parameter_data: Array[float] = module.get_parameters()
		var parameter_count := parameter_data.size()
		parameter_offsets.append(initial_memory_data.size())
		initial_memory_data.append_array(parameter_data)
	
	var connection_map : Dictionary[Node_Connection, int] # Node_Connection -> index in memory data
	for module in layout.modules:
		if module.get_type() == -1: # Constant Module
			connection_map[module.get_outputs()[0]] = initial_memory_data.size()
			initial_memory_data.append(module.get_parameters()[0])
			continue
		var module_outputs := module.get_outputs()
		
		var output_data: Array[float] = [] # create empty array of output values
		output_data.resize(module_outputs.size())
		
		output_offsets.append(initial_memory_data.size())
		var i := 0
		for output in module_outputs: # loop through each ConnectionModule and writing down its index
			connection_map[output] = initial_memory_data.size() + i
			i += 1
		
		initial_memory_data.append_array(output_data) # append the empty array to memory
	
	for module in layout.modules:
		if module.get_type() == -1: # Constant Module
			continue
		var module_inputs := module.get_inputs()
		
		input_offsets.append(input_routes.size())
		
		for input in module_inputs: # loop through all inputs and push the output index to input_routee
			input_routes.append(connection_map[input])
	
	voice.set_layout(
		types,
		input_offsets,
		output_offsets,
		state_offsets,
		parameter_offsets,
		input_routes,
		initial_memory_data
	)
	
	return voice

static func chord_to_polyvoice(
	chord : Chord,
	layout : Node_Layout
) -> Node_Polyvoice:
	var polyvoice := Node_Polyvoice.new()
	polyvoice.voices = []
	
	var notes := chord.notes
	for note : Semitone in notes:
		var new_voice := layout_to_voice(layout)
		
		new_voice.frequency = note.to_frequency()
		new_voice.active = false
		polyvoice.voices.append(new_voice)
	
	return polyvoice

static func chords_to_polyvoices(
	chords : Array[Chord],
	layout : Node_Layout,
) -> Array[Node_Polyvoice]:
	var polyvoices : Array[Node_Polyvoice]
	for chord in chords:
		polyvoices.append(chord_to_polyvoice(chord, layout))
	return polyvoices
