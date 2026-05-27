extends Node

var held_actions: Array[String] = []

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	for i in range(7):
		var action := "Key%d" % (i + 1)

		if Input.is_action_just_pressed(action):
			held_actions.erase(action)
			held_actions.append(action)

			# Turn ONLY this key on
			AudioEngine.voice_manager.voice_on(i)

		if Input.is_action_just_released(action):
			held_actions.erase(action)

			# Turn ONLY this key off
			AudioEngine.voice_manager.voice_off(i)

			# If another key is still held, retrigger newest held key
			if held_actions.size() > 0:
				var last_action = held_actions[-1]
				var last_index = int(last_action.trim_prefix("Key")) - 1

				AudioEngine.voice_manager.voice_on(last_index)
