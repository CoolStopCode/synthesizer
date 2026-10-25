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
	layout = save.to_layout(layout_scene, module_bindings)
	
	center_node.add_child(layout)

func make_save() -> ModularSave:
	return layout.to_save()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug"):
		var audio_layout := layout.to_voice_layout()
		audio.voice_layout = audio_layout
		audio.build()

func _ready() -> void:
	load_save(preload("res://stages/modular/save/default_save.tres"))
