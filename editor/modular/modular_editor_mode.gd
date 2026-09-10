class_name ModularEdtiorMode
extends EditorMode

@export var default_save : ModularEditorSave

@export_group("private")
@export var module_bindings : Dictionary[int, PackedScene]

@export var top_node : Control
@export var workspace_node : Control
@export var bottom_node : Control

@export var layout_scene : PackedScene
var layout : ModularEditorLayout

func load_save(save : EditorSave):
	if save != null:
		layout = save.to_editor_layout(layout_scene, module_bindings)
	else:
		layout = default_save.to_editor_layout(layout_scene, module_bindings)
	
	workspace_node.add_child(layout)

func _ready() -> void:
	load_save(null)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		var audio_layout := layout.to_audio_layout()
		(audio_mode as ModularAudioMode).layout = audio_layout
		(audio_mode as ModularAudioMode).build()
		
		var save := layout.to_save()
		ResourceSaver.save(save, "res://editor/modular/save/default_save.tres")
