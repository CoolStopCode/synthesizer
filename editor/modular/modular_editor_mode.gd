class_name ModularEditorMode
extends EditorMode

@export var workspace : Control
@export var modules_parent : Control
@export var connections_parent : Control
@export var connection_scene : PackedScene
@export var input_module_scene : PackedScene
@export var output_module_scene : PackedScene
@export var modules : Array[ModularEditorModule]
@export var connections : Array[ModularEditorConnection]

signal port_down(port : ModularEditorPort)
signal port_up(port : ModularEditorPort)
signal start_connection_search(from : ModularEditorPort)
signal stop_connection_search(to : ModularEditorPort)

func _ready() -> void:
	var input := create_module(input_module_scene)
	var output := create_module(output_module_scene)
	input.position = Vector2(0, 0)
	output.position = Vector2(0, 44)
	create_module(preload("res://editor/modular/modules/envelope/modular_editor_envelope.tscn"))

func create_module(module_scene : PackedScene) -> ModularEditorModule:
	var module_instance := module_scene.instantiate() as ModularEditorModule
	
	module_instance.build()
	module_instance.port_down.connect(port_down.emit)
	module_instance.port_up.connect(port_up.emit)
	module_instance.position = get_position_for_new_module(module_instance.size)
	
	for port in module_instance.ports:
		start_connection_search.connect(port.start_connection_search)
		stop_connection_search.connect(port.stop_connection_search)
	
	modules.append(module_instance)
	modules_parent.add_child(module_instance)
	
	return module_instance

func get_position_for_new_module(dimensions : Vector2) -> Vector2:
	var origin : Vector2 = Vector2(0, 0)
	
	var corner_points : Array[Vector2]
	corner_points.append(origin)
	
	# Add the top right and bottom left corner of each module to a list
	for module in modules:
		var top_right : Vector2 = module.position + Vector2(module.size.x, 0.0)
		var bottom_left : Vector2 = module.position + Vector2(0.0, module.size.y)
		corner_points.append(top_right)
		corner_points.append(bottom_left)
	
	# Filter the list down, removing corners already inside a module and
	# positions where the new module wouldn't fit
	var candidate_points : Array[Vector2]
	var workspace_bottom : float = workspace.size.y
	for corner_point in corner_points:
		if corner_point.y + dimensions.y > workspace_bottom: continue
		
		var should_continue : bool = false
		for module in modules:
			if corner_point == module.position:
				should_continue = true
				break
			if corner_point.x == module.position.x\
			and corner_point.y > module.position.y\
			and corner_point.y < module.position.y + module.size.y:
				should_continue = true
				break
		if should_continue: continue
		
		candidate_points.append(corner_point)
	
	# Find the closest point to the origin
	var closest : Vector2 = Vector2(INF, INF)
	var closest_distance : float = INF
	for candidate_point in candidate_points:
		var distance := candidate_point.distance_to(origin)
		if distance < closest_distance:
			closest = candidate_point
			closest_distance = distance
	
	return closest

func _on_port_down(port : ModularEditorPort) -> void:
	if not port.in_use: create_connection(port)

func create_connection(from : ModularEditorPort) -> void:
	var connection_instance : ModularEditorConnection = connection_scene.instantiate()
	
	connection_instance.from = from
	connection_instance.to = null
	connection_instance.modules = modules
	
	start_connection_search.emit(from)
	connection_instance.start_connection_search.connect(start_connection_search.emit)
	connection_instance.stop_connection_search.connect(stop_connection_search.emit)
	
	connections.append(connection_instance)
	connections_parent.add_child(connection_instance)

func build_voice() -> ModularAudioVoice: # TODO: Redo this
	var voice := ModularAudioVoice.new()
	
	var types : PackedByteArray
	
	var input_offsets : PackedInt32Array
	var output_offsets : PackedInt32Array
	var state_offsets : PackedInt32Array
	var parameter_offsets : PackedInt32Array
	
	var input_routes : PackedInt32Array 
	var initial_memory_data : PackedFloat64Array
	initial_memory_data.append_array([0.0, 0.0, 0.0, 0.0])
	
	for module in modules:
		var type := module.type_id
		
		var module_states := module.states
		var module_parameters := module.parameters
		
		types.append(type)
		
		var state_data: Array[float] = module.get_states()
		state_offsets.append(initial_memory_data.size())
		initial_memory_data.append_array(state_data)
		
		var parameter_data: Array[float] = module.get_parameters()
		parameter_offsets.append(initial_memory_data.size())
		initial_memory_data.append_array(parameter_data)
	
	var connection_map : Dictionary[ModularEditorPort, ModularEditorPort]
	for connection in connections:
		if connection.from.is_input_port():
			connection_map[connection.from] = connection.to
		elif connection.from.is_output_port():
			connection_map[connection.to] = connection.from
	
	var output_index_map : Dictionary[ModularEditorPort, int]
	for module in modules:
		var output_ports : Array[ModularEditorPort]
		for port in module.ports:
			if port.is_output_port():
				output_ports.append(port)
		
		for i in range(output_ports.size()):
			var output_port := output_ports[i]
			output_index_map[output_port] = initial_memory_data.size() + i
		
		var output_data: Array[float]
		output_data.resize(output_ports.size())
		output_offsets.append(initial_memory_data.size())
		initial_memory_data.append_array(output_data)
	
	for module in modules:
		var input_ports : Array[ModularEditorPort]
		for port in module.ports:
			if port.is_input_port():
				input_ports.append(port)
		
		input_offsets.append(input_routes.size())
		
		for input_port in input_ports:
			input_routes.append(output_index_map[connection_map[input_port]])
	
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
