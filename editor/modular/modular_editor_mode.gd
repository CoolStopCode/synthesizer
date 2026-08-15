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
