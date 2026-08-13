class_name ModularEditorMode
extends EditorMode

@export var workspace : Control
@export var modules_parent : Control
@export var connections_parent : Control
@export var connection_scene : PackedScene

signal port_down(port : ModularEditorPort)
signal port_up(port : ModularEditorPort)

var searching
# IN PROGRESS
func _ready() -> void:
	var input := create_module(preload("res://editor/modular/modules/input/modular_editor_input_module.tscn"))
	var output := create_module(preload("res://editor/modular/modules/output/modular_editor_output_module.tscn"))
	input.position = Vector2(0, 0)
	output.position = Vector2(0, 44)

# FINAL
func create_module(module_scene : PackedScene) -> ModularEditorModule:
	var module_instance : ModularEditorModule = module_scene.instantiate()
	
	if not module_instance is ModularEditorModule: return
	
	module_instance.build()
	module_instance.port_down.connect(port_down.emit)
	module_instance.port_up.connect(port_up.emit)
	module_instance.position = get_position_for_new_module(module_instance.size)
	modules_parent.add_child(module_instance)
	
	return module_instance

# FINAL
func get_position_for_new_module(dimensions : Vector2) -> Vector2:
	var modules: Array[ModularEditorModule] = []
	modules.assign(modules_parent.get_children())
	
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
		if corner_point.y + dimensions.y > workspace_bottom:
			continue
		
		var should_continue : bool = false
		for module in modules:
			if corner_point == module.position:
				should_continue = true
				break
		if should_continue: continue
		
		candidate_points.append(corner_point)
	
	# Find the closest point to the origin
	var closest : Vector2 = Vector2(INF, INF)
	for candidate_point in candidate_points:
		var distance := candidate_point.distance_to(origin)
		if distance < closest.distance_to(origin):
			closest = candidate_point
	
	return closest

func _on_port_down(port: ModularEditorPort) -> void:
	if not port.in_use: create_connection(port)

func create_connection(from : ModularEditorPort) -> void:
	var connection_instance : ModularEditorConnection = connection_scene.instantiate()
	
	connection_instance.from = from
	connection_instance.to = null
	connection_instance.modules_parent = modules_parent
	
	connections_parent.add_child(connection_instance)
