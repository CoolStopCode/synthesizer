@icon("res://tools/at-icons/node/controller.svg")
extends Node

@export var audio : Audio

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	if Input.is_action_just_pressed("Debug"):
		audio.build()
	
	for i in range(7):
		var action := "Key%d" % (i + 1)
		if Input.is_action_just_pressed(action):
			audio.key_pressed(i)
		if Input.is_action_just_released(action):
			audio.key_released(i)
	
	var bend : Vector3i
	bend = Vector3i(
		int( Input.is_action_pressed("Bend1") ),
		int( Input.is_action_pressed("Bend2") ),
		int( Input.is_action_pressed("Bend3") )
	)
	
	var any_just_changed := (
		Input.is_action_just_pressed("Bend1") or Input.is_action_just_released("Bend1") or
		Input.is_action_just_pressed("Bend2") or Input.is_action_just_released("Bend2") or
		Input.is_action_just_pressed("Bend3") or Input.is_action_just_released("Bend3")
	)
	
	if any_just_changed:
		audio.bend_changed(bend)
