extends Node

const MULTI_KEY := false

var active_keys: Array[int] = []
var active_index: int = -1

# Store the path to the button for cleaner code
@onready var interface_button1 = get_node("/root/window/SubViewportContainer/SubViewport/main/CenterContainer/GridContainer/interface_button")
@onready var interface_button2 = get_node("/root/window/SubViewportContainer/SubViewport/main/CenterContainer/GridContainer/interface_button2")
@onready var interface_button3 = get_node("/root/window/SubViewportContainer/SubViewport/main/CenterContainer/GridContainer/interface_button3")

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	# Check if the interface button is pressed
	if interface_button1.is_pressed:
		AudioEngine.voice_manager.polyvoice_on(0)
	else:
		AudioEngine.voice_manager.polyvoice_off(0)
	
	if interface_button2.is_pressed:
		AudioEngine.voice_manager.polyvoice_on(2)
	else:
		AudioEngine.voice_manager.polyvoice_off(2)
	
	if interface_button3.is_pressed:
		AudioEngine.voice_manager.polyvoice_on(5)
	else:
		AudioEngine.voice_manager.polyvoice_off(5)

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
