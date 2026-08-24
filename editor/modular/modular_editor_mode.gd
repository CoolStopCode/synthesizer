class_name ModularEditorMode
extends EditorMode

@export var modules_layer : ModularEditorModulesLayer
@export var connections_layer : ModularEditorConnectionsLayer

@export var input_module_scene : PackedScene
@export var output_module_scene : PackedScene

var dragging_connection : ModularEditorConnection

func _ready() -> void:
	var input := modules_layer.create_module(input_module_scene)
	var output := modules_layer.create_module(output_module_scene)
	input.position = Vector2(0, 0)
	output.position = Vector2(0, 44)
	modules_layer.create_module(preload("res://editor/modular/module/envelope/modular_editor_envelope_module.tscn"))
	modules_layer.create_module(preload("res://editor/modular/module/oscillator/modular_editor_oscillator_module.tscn"))

func _on_modules_layer_gui_input(event: InputEvent) -> void:
	print("EEE")
	if not (event is InputEventMouseButton or event is InputEventScreenTouch): return
	
	var closest_port := modules_layer.closest_port_to(event.global_position)
	
	if event.is_pressed():
		if closest_port.in_click_area(event.global_position):
			port_clicked(closest_port)
	else:
		if dragging_connection != null:
			release_connection(closest_port, event.global_position)

func release_connection(port: ModularEditorPort, event_position : Vector2) -> void:
	modules_layer.highlight_off()
	
	if (not port.in_click_area(event_position))\
	or (not dragging_connection.can_connect_to(port)):
		dragging_connection.queue_free()
		return
	
	dragging_connection.connect_to_port(port)
	dragging_connection = null

func port_clicked(port: ModularEditorPort) -> void:
	if port.is_empty():
		if port.can_create_connection:
			modules_layer.highlight_on(port)
			dragging_connection = connections_layer.create_connection(port)
		else:
			port.clicked()
	else:
		var connection := port.connection
		dragging_connection = connection
		connection.lift_port(port)
		modules_layer.highlight_on(connection.get_connected_port())

func build_layout() -> ModularAudioLayout:
	var layout := ModularAudioLayout.new()
	
	var types : PackedByteArray
	var module_offsets : PackedInt32Array
	var output_offsets : PackedInt32Array
	
	var output_routes : PackedInt32Array
	var memory_data : PackedFloat64Array = PackedFloat64Array([0.0, 0.0, 0.0, 0.0])
	
	for module in modules_layer.modules:
		var type := module.type_id
		types.append(type)
		
		var module_data := module.get_module_data()
		
		module_offsets.append(memory_data.size())
		memory_data.append_array(module_data)
	
	var connection_map : Dictionary[ModularEditorOutputPort, ModularEditorInputPort]
	for connection in connections_layer.connections:
		connection_map[connection.output] = connection.input
	
	var input_map : Dictionary[ModularEditorInputPort, int] # Input port -> memory index
	for i in range(modules_layer.modules.size()):
		var module : ModularEditorModule = modules_layer.modules[i]
		var module_input_map : Array[ModularEditorInputPort] = module.get_input_map()
		var module_offset : int = module_offsets[i]
		
		for j in range(module_input_map.size()):
			var module_input : ModularEditorInputPort = module_input_map[j]
			if module_input == null: continue
			input_map[module_input] = module_offset + j
			
	
	var output_map : Dictionary[ModularEditorOutputPort, int] # Output port -> memory index
	for i in range(modules_layer.modules.size()):
		var module : ModularEditorModule = modules_layer.modules[i]
		var module_output_map : Array[ModularEditorOutputPort] = module.get_output_map()
		
		for j in range(module_output_map.size()):
			var module_output : ModularEditorOutputPort = module_output_map[j]
			if module_output == null: continue
			if not connection_map.has(module_output): continue
			output_map[module_output] = input_map[connection_map[module_output]]
	
	for i in range(modules_layer.modules.size()):
		var module : ModularEditorModule = modules_layer.modules[i]
		var module_output_map : Array[ModularEditorOutputPort] = module.get_output_map()
		
		output_offsets.append(output_routes.size())
		for j in range(module_output_map.size()):
			var module_output : ModularEditorOutputPort = module_output_map[j]
			if module_output == null: continue
			if output_map.has(module_output):
				output_routes.append(output_map[module_output])
			else:
				output_routes.append(0) # Unconnected -> unused slot 0
	
	layout.types = types
	layout.module_offsets = module_offsets
	layout.output_offsets = output_offsets
	layout.output_routes = output_routes
	layout.memory_data = memory_data
	
	return layout
