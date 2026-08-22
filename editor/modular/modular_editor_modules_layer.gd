class_name ModularEditorModulesLayer
extends Control

@export var modules : Array[ModularEditorModule]

func create_module(module_scene : PackedScene) -> ModularEditorModule:
	var module_instance := module_scene.instantiate() as ModularEditorModule
	
	module_instance.position = get_position_for_new_module(module_instance.size, 88)
	
	modules.append(module_instance)
	add_child(module_instance)
	
	return module_instance

func get_position_for_new_module(module_size : Vector2, workspace_height : float) -> Vector2:
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
	for corner_point in corner_points:
		if corner_point.y + module_size.y > workspace_height: continue
		
		var should_continue : bool = false
		for module in modules:
			if corner_point == module.position:
				should_continue = true
				break
			if  corner_point.y >= module.position.y\
			and corner_point.y < module.position.y + module.size.y\
			and corner_point.x >= module.position.x\
			and corner_point.x < module.position.x + module.size.x:
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

func get_all_ports() -> Array[ModularEditorPort]:
	var ports : Array[ModularEditorPort]
	
	for module : ModularEditorModule in modules:
		for port : ModularEditorPort in module.ports:
			ports.append(port)
	
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

func highlight_on(from : ModularEditorPort) -> void:
	for module in modules:
		for port in module.ports:
			if port.is_compatible_with(from):
				port.highlight_on()

func highlight_off() -> void:
	for module in modules:
		for port in module.ports:
			port.highlight_off()
