class_name ModularModulesLayer
extends Control

@export var modules : Array[ModularModule]

func create_new_module(module_scene : PackedScene) -> ModularModule:
	var module_instance : ModularModule = module_scene.instantiate()
	module_instance.position = get_new_module_position(module_instance)
	add_child(module_instance)
	modules.append(module_instance)
	return module_instance

func create_module_at(module_scene : PackedScene, module_position : Vector2) -> ModularModule:
	var module_instance : ModularModule = create_module(module_scene)
	module_instance.position = module_position
	return module_instance

func create_module(module_scene : PackedScene) -> ModularModule:
	var module_instance : ModularModule = module_scene.instantiate()
	add_child(module_instance)
	modules.append(module_instance)
	return module_instance

func get_new_module_position(new_module : ModularModule) -> Vector2:
	var candidate_positions : Array[Vector2]
	candidate_positions.append(Vector2(0, 0))
	for module in modules:
		if module == new_module: continue
		candidate_positions.append(module.position + Vector2(module.size.x, 0            ))
		candidate_positions.append(module.position + Vector2(0            , module.size.y))
		candidate_positions.append(module.position + Vector2(module.size.x, module.size.y))
	
	var best_position := Vector2.INF
	for candidate_position in candidate_positions:
		var candidate_rect := Rect2(candidate_position, new_module.size)
		if not is_module_rect_in_valid_position(candidate_rect): continue
		
		var candidate_distance := candidate_position.distance_to(Vector2(0, 0))
		var best_distance      := best_position     .distance_to(Vector2(0, 0))
		if candidate_distance < best_distance:
			best_position = candidate_position
	
	return best_position

func is_module_rect_in_valid_position(module_rect : Rect2) -> bool:
	#if not get_rect().grow(0.00001).encloses(module_rect): return false
	
	for module in modules:
		if module.get_rect().intersects(module_rect): return false
	
	return true

func get_module(module_index : int) -> ModularModule:
	return modules[module_index]

func get_all_ports() -> Array[ModularPort]:
	var ports : Array[ModularPort]
	
	for module : ModularModule in modules:
		for parameter : ModularParameter in module.parameters:
			if parameter is ModularPort:
				ports.append(parameter)
		for output : ModularOutputPort in module.outputs:
			ports.append(output)
	
	return ports

func closest_port_to(point : Vector2) -> ModularPort:
	var closest_distance : float = INF
	var closest_port : ModularPort
	for port : ModularPort in get_all_ports():
		var distance := point.distance_to(port.global_center_position())
		if distance < closest_distance:
			closest_distance = distance
			closest_port = port
	
	return closest_port

#func highlight_on(from : ModularPort) -> void:
	#for port in get_all_ports():
		#if port.can_connect_to(from):
			#port.highlight_on()
#
#func highlight_off() -> void:
	#for port in get_all_ports():
		#port.highlight_off()

func get_module_definitions() -> Array[ModularModuleDefinition]:
	var module_definitions : Array[ModularModuleDefinition]
	
	for module in modules:
		var module_definition := ModularModuleDefinition.new()
		module_definition.id               = module.id
		module_definition.position         = module.position
		module_definition.parameter_values = module.get_parameter_values()
		module_definition.output_count     = module.outputs.size()
		module_definitions.append(module_definition)
	
	return module_definitions

func get_input_map() -> Dictionary[ModularInputPort, Vector2i]:
	var input_map : Dictionary[ModularInputPort, Vector2i]
	
	for module_index in range(modules.size()):
		var module := modules[module_index]
		for parameter_index in range(module.parameters.size()):
			var parameter := module.parameters[parameter_index]
			if parameter is ModularInputPort:
				var input := parameter as ModularInputPort
				input_map[input] = Vector2i(module_index, parameter_index)
	
	return input_map

func get_output_map() -> Dictionary[ModularOutputPort, Vector2i]:
	var output_map : Dictionary[ModularOutputPort, Vector2i]
	for module_index in range(modules.size()):
		var module := modules[module_index]
		for output_index in range(module.outputs.size()):
			var output := module.outputs[output_index]
			output_map[output] = Vector2i(module_index, output_index)
	return output_map
