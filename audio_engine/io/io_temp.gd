extends Node

const MULTI_KEY := false

var active_keys: Array[int] = []
var active_index: int = -1

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	for i in range(7):
		var action := "Key%d" % (i + 1)

		if Input.is_action_just_pressed(action):
			if MULTI_KEY:
				if not active_keys.has(i):
					active_keys.append(i)
					AudioEngine.voice_manager.polyvoice_on(i)
			else:
				if active_index != -1 and active_index != i:
					AudioEngine.voice_manager.polyvoice_off(active_index)

				active_index = i
				AudioEngine.voice_manager.polyvoice_on(i)

		if Input.is_action_just_released(action):
			if MULTI_KEY:
				if active_keys.has(i):
					active_keys.erase(i)
					AudioEngine.voice_manager.polyvoice_off(i)
			else:
				if active_index == i:
					AudioEngine.voice_manager.polyvoice_off(i)
					active_index = -1
