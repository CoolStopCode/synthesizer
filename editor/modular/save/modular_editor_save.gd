class_name ModularEditorSave
extends EditorSave

@export var module_definitions : Array[ModularEditorModuleDefinition]
@export var connection_definitions : Array[ModularEditorConnectionDefinition]

func to_editor_layout(layout_scene : PackedScene, module_bindings : Dictionary[int, PackedScene]) -> ModularEditorLayout:
	var layout : ModularEditorLayout = layout_scene.instantiate()
	
	for module_definition in module_definitions:
		var module_scene : PackedScene = module_bindings[module_definition.id]
		var module_position : Vector2 = module_definition.position
		var module_instance := layout.modules_layer.create_module_at(module_scene, module_position)
		for i in range(module_definition.parameter_values.size()):
			var parameter_value := module_definition.parameter_values[i]
			var parameter := module_instance.parameters[i]
			if parameter != null:
				parameter.set_value(parameter_value)
	
	for connection_definition in connection_definitions:
		var input_port : ModularEditorInputPort = layout.modules_layer\
			.modules[connection_definition.input_module_index]\
			.parameters[connection_definition.input_parameter_index]
		var output_port : ModularEditorOutputPort = layout.modules_layer\
			.modules[connection_definition.output_module_index]\
			.outputs[connection_definition.output_output_index]
		
		layout.connections_layer.create_connection_at(input_port, output_port)
	
	return layout
