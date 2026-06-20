extends Node

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	for i in range(7):
		var action := "Key%d" % (i + 1)
		if Input.is_action_just_pressed(action):
			AudioEngine.key_pressed(i)
		if Input.is_action_just_released(action):
			AudioEngine.key_released(i)
