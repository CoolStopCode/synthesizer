class_name VoiceBuilder

static func graph_to_voice(graph : VoiceGraph) -> Voice:
	var voice := Voice.new()
	
	var types : PackedByteArray
	
	var input_offsets : PackedInt32Array
	var input_counts : PackedInt32Array
	
	var output_offsets : PackedInt32Array
	var output_counts : PackedInt32Array
	
	var state_offsets : PackedInt32Array
	var state_counts : PackedInt32Array
	
	var parameter_offsets : PackedInt32Array
	var parameter_counts : PackedInt32Array
	
	var input_routes : PackedInt32Array
	var initial_memory_data : PackedFloat64Array
	initial_memory_data.append_array([0.0, 0.0, 0.0, 0.0])
	
	for module in graph.modules:
		var type := module.get_type()
		var module_states := module.get_states()
		var module_parameters := module.get_parameters()
		
		types.append(type)
		
		# STATES
		var state_data: Array[float] = module.get_states()
		var state_count := state_data.size()
		state_offsets.append(initial_memory_data.size())
		state_counts.append(state_count)
		initial_memory_data.append_array(state_data)
		
		# PARAMETERS
		var parameter_data: Array[float] = module.get_parameters()
		var parameter_count := parameter_data.size()
		parameter_offsets.append(initial_memory_data.size())
		parameter_counts.append(parameter_count)
		initial_memory_data.append_array(parameter_data)
	
	var connection_map : Dictionary[GraphConnection, int] # GraphConnection -> index in memory data
	for module in graph.modules:
		var module_outputs := module.get_outputs()
		var output_count := module_outputs.size()
		
		var output_data: Array[float] = [] # create empty array of output values
		output_data.resize(module_outputs.size())
		
		output_offsets.append(initial_memory_data.size())
		output_counts.append(output_count)
		var i := 0
		for output in module_outputs: # loop through each ConnectionModule and writing down its index
			connection_map[output] = initial_memory_data.size() + i
			i += 1
		
		initial_memory_data.append_array(output_data) # append the empty array to memory
	
	for module in graph.modules:
		var module_inputs := module.get_inputs()
		var input_count := module_inputs.size()
		
		input_offsets.append(input_routes.size())
		input_counts.append(input_count)
		
		for input in module_inputs: # loop through all inputs and push the output index to input_routee
			assert(connection_map.has(input), "Unbonded input on module type %d" % module.get_type())
			input_routes.append(connection_map[input])
	
	voice.set_graph(
		types,
		input_offsets,
		input_counts,
		output_offsets,
		output_counts,
		state_offsets,
		state_counts,
		parameter_offsets,
		parameter_counts,
		input_routes,
		initial_memory_data
	)
	
	return voice
