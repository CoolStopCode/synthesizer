class_name ModularAudioLayout
extends Resource

@export var modules : Array[ModularAudioModule]

## Converts itself to a the C++ GDExtension object, which can be processed much faster
func to_voice() -> ModularAudioVoice:
	var voice := ModularAudioVoice.new()
	
	var types : PackedByteArray # The types of each module, e.g. Oscillator, Filter 
	
	var input_offsets : PackedInt32Array
	var output_offsets : PackedInt32Array
	var state_offsets : PackedInt32Array
	var parameter_offsets : PackedInt32Array
	
	# Chunks of memory_data indices. Because modules can only read from chunks of data,
	# input routes are needed because the outputs of modules aren't always in chunks
	var input_routes : PackedInt32Array 
	var initial_memory_data : PackedFloat64Array
	initial_memory_data.append_array([0.0, 0.0, 0.0, 0.0]) # Unused, frequency in, active in, sample out
	
	# States: local information read and written by the module
	# Parameters: constants inputted by the user
	# Inputs: offsets point to input routes, unlike the others which offsets point to memory data. Read only
	# Outputs: write only
	for module in modules: # Parameters and states
		if module == null: continue
		
		var type := module.get_type()
		if type == -1: continue # Constant module
		
		var module_states := module.get_states()
		var module_parameters := module.get_parameters()
		
		types.append(type) # Append the type integer as a signle byte. Can't have more than 256 modules
		
		# States
		var state_data: Array[float] = module.get_states()
		state_offsets.append(initial_memory_data.size())
		initial_memory_data.append_array(state_data)
		
		# Parameters
		var parameter_data: Array[float] = module.get_parameters()
		parameter_offsets.append(initial_memory_data.size())
		initial_memory_data.append_array(parameter_data)
	
	var connection_map : Dictionary[ModularAudioConnection, int] # ModularAudioConnection -> index in memory data
	for module in modules: # Outputs
		if module == null: continue
		
		var type := module.get_type()
		if type == -1: # Constant Module
			connection_map[module.get_outputs()[0]] = initial_memory_data.size()
			initial_memory_data.append(module.get_parameters()[0])
			continue
		
		var module_outputs := module.get_outputs()
		var module_output_count := module_outputs.size()
		
		for i in range(module_output_count): # Iterate over each output connection and note its memory location
			var output := module_outputs[i]
			connection_map[output] = initial_memory_data.size() + i
		
		var output_data: Array[float] = []
		output_data.resize(module_output_count)
		output_offsets.append(initial_memory_data.size()) # Outputs start out as empty
		initial_memory_data.append_array(output_data)
	
	for module in modules: # Inputs
		if module == null: continue
		
		var type := module.get_type()
		if type == -1: continue # Constant Module
		
		var module_inputs := module.get_inputs()
		var module_input_count := module_inputs.size()
		
		input_offsets.append(input_routes.size())
		
		for input in module_inputs: # Iterate over inputs and append the output index to input routes
			input_routes.append(connection_map[input])
	
	voice.set_layout( # C++ GDExtension
		types,
		input_offsets,
		output_offsets,
		state_offsets,
		parameter_offsets,
		input_routes,
		initial_memory_data
	)
	
	return voice

func to_polyvoice(
	voice_count : int
) -> ModularAudioPolyvoice:
	var polyvoice := ModularAudioPolyvoice.new()
	polyvoice.voices = []
	
	for i in range(voice_count):
		var new_voice : ModularAudioVoice = to_voice()
		polyvoice.voices.append(new_voice)
	
	return polyvoice

func to_polyvoices(
	polyvoice_count : int,
	voice_count : int
) -> Array[ModularAudioPolyvoice]:
	var polyvoices : Array[ModularAudioPolyvoice]
	for i in range(polyvoice_count):
		polyvoices.append(to_polyvoice(voice_count))
	return polyvoices
