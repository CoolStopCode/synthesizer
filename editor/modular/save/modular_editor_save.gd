class_name ModularEditorSave
extends EditorSave

@export var module_definitions : Array[ModularEditorModuleDefinition]
@export var connection_definitions : Array[ModularEditorConnectionDefinition]

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
