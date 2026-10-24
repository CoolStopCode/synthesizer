class_name ModularStage
extends Stage

@export var audio : ModularAudio

@export_group("private")
@export var module_bindings : Dictionary[int, PackedScene]
@export var top_node : Control
@export var center_node : Control
@export var bottom_node : Control
@export var layout_scene : PackedScene

var layout : ModularLayout

func load_save(save : ModularSave) -> void:
	layout = save.to__layout(layout_scene, module_bindings)
	
	center_node.add_child(layout)

func make_save() -> ModularSave:
	return layout.to_save()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		var audio_layout := layout.to_audio_layout()
		audio.layout = audio_layout
		audio.build()
