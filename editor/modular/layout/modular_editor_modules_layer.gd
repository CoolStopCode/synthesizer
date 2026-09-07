class_name ModularEditorModulesLayer
extends Control

@export var modules : Array[ModularEditorModule]

func create_new_module(module_scene : PackedScene) -> ModularEditorModule:
	var module_instance : ModularEditorModule = module_scene.instantiate()
	module_instance.position = get_new_module_position(module_instance)
	add_child(module_instance)
	modules.append(module_instance)
	return module_instance

func create_module_at(module_scene : PackedScene, module_position : Vector2) -> ModularEditorModule:
	var module_instance : ModularEditorModule = create_module(module_scene)
	module_instance.position = module_position
	return module_instance

func create_module(module_scene : PackedScene) -> ModularEditorModule:
	var module_instance : ModularEditorModule = module_scene.instantiate()
	add_child(module_instance)
	modules.append(module_instance)
	return module_instance

func get_new_module_position(new_module : ModularEditorModule) -> Vector2:
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

func get_module(module_index : int) -> ModularEditorModule:
	return modules[module_index]

func get_all_ports() -> Array[ModularEditorPort]:
	var ports : Array[ModularEditorPort]
	
	for module : ModularEditorModule in modules:
		for parameter : ModularEditorParameter in module.parameters:
			if parameter is ModularEditorPort:
				ports.append(parameter)
	
	return ports

func closest_port_to(point : Vector2) -> ModularEditorPort:
	var closest_distance : float = INF
	var closest_port : ModularEditorPort
	for port : ModularEditorPort in get_all_ports():
		var distance := point.distance_to(port.global_center_position())
		if distance < closest_distance:
			closest_distance = distance
			closest_port = port
	
	return closest_port

#func highlight_on(from : ModularEditorPort) -> void:
	#for port in get_all_ports():
		#if port.can_connect_to(from):
			#port.highlight_on()
#
#func highlight_off() -> void:
	#for port in get_all_ports():
		#port.highlight_off()

func get_module_parameter(module_index : int, parameter_index : int) -> ModularEditorParameter:
	return modules[module_index].parameters[parameter_index]

func get_module_definitions() -> Array[ModularEditorModuleDefinition]:
	var module_definitions : Array[ModularEditorModuleDefinition]
	for module in modules:
		var module_definition := ModularEditorModuleDefinition.new(
			module.id,
			module.position,
			module.get_parameter_values(),
			module.output_count
		)
		module_definitions.append(module_definition)
	
	return module_definitions

func get_parameter_map() -> Dictionary[ModularEditorParameter, Vector2i]:
	var parameter_map : Dictionary[ModularEditorParameter, Vector2i] # (module index, parameter index
	for module_index in range(modules.size()):
		var module := modules[module_index]
		for parameter_index in range(module.parameters.size()):
			parameter_map[modules[module_index].parameters[parameter_index]] = Vector2i(module_index, parameter_index)
	return parameter_map
