class_name ModularEditorSave
extends EditorSave

func new_module_definition(
	id : int,
	position : Vector2,
	parameter_values : Array[float],
	output_count : int
) -> void:
	var module_definition := ModuleDefinition.new()
	module_definition.id = id
	module_definition.position = position
	module_definition.parameter_values = parameter_values
	module_definition.output_count = output_count
	module_definitions.append(module_definition)

func new_connection_definition(
	input_module_index : int,
	input_parameter_index : int,
	output_module_index : int,
	output_parameter_index : int
) -> void:
	var connection_definition := ConnectionDefinition.new()
	connection_definition.input_module_index = input_module_index
	connection_definition.input_parameter_index = input_parameter_index
	connection_definition.output_module_index = output_module_index
	connection_definition.output_parameter_index = output_parameter_index
	connection_definitions.append(connection_definition)

class ModuleDefinition extends Resource:
	var id : int
	var position : Vector2
	var parameter_values : Array[float]
	var output_count : int

class ConnectionDefinition extends Resource:
	var input_module_index : int
	var input_parameter_index : int
	var output_module_index : int
	var output_parameter_index : int

@export var module_definitions : Array[ModuleDefinition]
@export var connection_definitions : Array[ConnectionDefinition]

func to_editor_layout(layout_scene : PackedScene, module_bindings : ModularEditorModuleBindings) -> ModularEditorLayout:
	var layout : ModularEditorLayout = layout_scene.instantiate()
	
	layout.create_children()
	
	for module_definition in module_definitions:
		var module_scene : PackedScene = module_bindings.module_bindings[module_definition.id]
		var module_position : Vector2 = module_definition.position
		var module_instance := layout.modules_layer.create_module_at(module_scene, module_position)
		for i in range(module_definition.parameter_values.size()):
			var parameter_value := module_definition.parameter_values[i]
			var parameter := module_instance.parameters[i]
			parameter.initialize_value(parameter_value)
	
	for connection_definition in connection_definitions:
		var input_port : ModularEditorInputPort = layout.get_module_parameter(
			connection_definition.input_module_index,
			connection_definition.input_parameter_index
		)
		var output_port : ModularEditorOutputPort = layout.get_module_parameter(
			connection_definition.output_module_index,
			connection_definition.output_parameter_index
		)
		layout.create_connection(input_port, output_port)
	
	return layout

func to_audio_layout() -> ModularAudioLayout:
	var layout := ModularAudioLayout.new()
	
	var types : PackedByteArray
	var module_offsets : PackedInt32Array
	var output_offsets : PackedInt32Array
	
	var output_routes : PackedInt32Array
	var memory_data : PackedFloat64Array = PackedFloat64Array([0.0, 0.0, 0.0, 0.0])
	
	for i in range(module_definitions.size()):
		var module_definition := module_definitions[i]
		
		types.append(module_definition.id as int)
		module_offsets.append(memory_data.size())
		memory_data.append_array(module_definition.parameter_values)
	
	for i in range(module_definitions.size()):
		var module_definition := module_definitions[i]
		
		output_offsets.append(output_routes.size())
		
		var module_output_routes : PackedInt32Array
		module_output_routes.resize(module_definition.output_count)
		
		for connection_definition in connection_definitions:
			if connection_definition.output_module_index == i:
				module_output_routes[connection_definition.output_parameter_index] =\
					module_offsets[connection_definition.input_module_index] + connection_definition.input_parameter_index
			
		output_routes.append_array(module_output_routes)
	
	layout.types = types
	layout.module_offsets = module_offsets
	layout.output_offsets = output_offsets
	layout.output_routes = output_routes
	layout.memory_data = memory_data
	
	return layout
