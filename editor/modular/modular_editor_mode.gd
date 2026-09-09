class_name ModularEdtiorMode
extends EditorMode

func load_save(save : EditorSave):
	if save != null:
		layout = save.to_editor_layout(layout_scene, module_bindings)
	else:
		layout = default_save.to_editor_layout(layout_scene, module_bindings)
	
	workspace_node.add_child(layout)

@export var default_save : ModularEditorSave

@export_group("private")
@export var module_bindings : Dictionary[int, PackedScene]

@export var layout_scene : PackedScene

@export var top_node : Control
@export var workspace_node : Control
@export var bottom_node : Control

@export var layout : ModularEditorLayout

func _ready() -> void:
	load_save(null)
