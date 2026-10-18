class_name ModularEdtiorWorkspace
extends EditorStage

@export var audio_mode : ModularAudioMode

@export_group("private")
@export var module_bindings : Dictionary[int, PackedScene]
@export var top_node : Control
@export var center_node : Control
@export var bottom_node : Control
@export var layout_scene : PackedScene

var layout : ModularEditorLayout

func load_save(save : ModularEditorSave) -> void:
	layout = save.to_editor_layout(layout_scene, module_bindings)
	
	center_node.add_child(layout)

func make_save() -> ModularEditorSave:
	return layout.to_save()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		var audio_layout := layout.to_audio_layout()
		(audio_mode as ModularAudioMode).layout = audio_layout
		(audio_mode as ModularAudioMode).build()
