class_name ModularEditorMode
extends EditorMode

@export var workspace : Control
@export var modules_parent : Control
@export var connections_parent : Control

signal port_pressed(port : ModularEditorPort)
signal port_released(port : ModularEditorPort)

var creating_connection : bool
var preview_connection : ModularEditorConnection

func _ready() -> void:
	var input := create_module(preload("res://editor/modular/modules/input/modular_editor_input_module.tscn"))
	var output := create_module(preload("res://editor/modular/modules/output/modular_editor_output_module.tscn"))
	input.position = Vector2(0, 0)
	output.position = Vector2(0, 44)

func create_module(module : PackedScene) -> ModularEditorModule:
	var instance : ModularEditorModule = module.instantiate()
	
	if not instance is ModularEditorModule: return
	
	instance.build()
	instance.port_pressed.connect(port_pressed.emit)
	instance.port_released.connect(port_released.emit)
	instance.position = get_position_for_new_module(instance.size)
	modules_parent.add_child(instance)
	
	return instance

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

func _on_port_pressed(port: ModularEditorPort) -> void:
	var connection := ModularEditorConnection.new()
	connection.width = 2
	preview_connection = connection
	connections_parent.add_child(connection)
	
	var from_position : Vector2
	var to_position : Vector2
	if port is ModularEditorInputPort:
		connection.to = port
		from_position = connection.to_local(get_global_mouse_position())
		to_position = connection.to_local(port.global_position)
	else:
		connection.from = port
		from_position = connection.to_local(port.global_position)
		to_position = connection.to_local(get_global_mouse_position())
	
	connection.add_point(from_position)
	connection.add_point(to_position)

func _on_port_released(port: ModularEditorPort) -> void:
	if preview_connection.from and port is ModularEditorOutputPort: 
		preview_connection.queue_free()
		return
	if preview_connection.to and port is ModularEditorInputPort:
		preview_connection.queue_free()
		return
	var from_position : Vector2
	var to_position : Vector2
	if port is ModularEditorOutputPort:
		preview_connection.from = port
		from_position = preview_connection.to_local(get_global_mouse_position())
		to_position = preview_connection.to_local(port.global_position)
	else:
		preview_connection.to = port
		from_position = preview_connection.to_local(port.global_position)
		to_position = preview_connection.to_local(get_global_mouse_position())
	
	preview_connection.add_point(from_position)
	preview_connection.add_point(to_position)
	
	preview_connection = null

func _unhandled_input(event: InputEvent) -> void:
	print("AAA")
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if not event.pressed:
			preview_connection.queue_free()
			creating_connection = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if preview_connection:
			if preview_connection.to:
				var from_position := preview_connection.to_local(get_global_mouse_position())
				preview_connection.set_point_position(0, from_position)
			else:
				var to_position := preview_connection.to_local(get_global_mouse_position())
				preview_connection.set_point_position(1, to_position)
