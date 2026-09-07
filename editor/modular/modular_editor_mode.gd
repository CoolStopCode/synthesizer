class_name ModularEdtiorMode
extends EditorMode

func load_save(save : EditorSave):
	if save != null:
		layout = save.to_editor_layout(module_bindings, layout_scene)
	else:
		layout = layout_scene.instantiate()
	
	workspace_node.add_child(layout)

@export_group("private")
@export var module_bindings : ModularEditorModuleBindings

@export var layout_scene : PackedScene

@export var top_node : Control
@export var workspace_node : Control
@export var bottom_node : Control

@export var layout : ModularEditorLayout

func _ready() -> void:
	load_save(null)
