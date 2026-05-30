extends Node

var held_action_indexes: Array[int] = []

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	for i in range(7):
		var action := "Key%d" % (i + 1)

		if Input.is_action_just_pressed(action):
			held_action_indexes.erase(i)
			held_action_indexes.append(i)

			# Turn ONLY this key on
			AudioEngine.voice_manager.voice_on(i)

		if Input.is_action_just_released(action):
			held_action_indexes.erase(i)

			# Turn ONLY this key off
			AudioEngine.voice_manager.voice_off(i)

			# If another key is still held, retrigger newest held key
			if held_action_indexes.size() > 0:
				var last_index = held_action_indexes[-1]

				AudioEngine.voice_manager.voice_on(last_index)
	
	var modifier_quality : Quality.Enum
	var joystick_moved : bool =\
		Input.is_action_just_pressed("Up")    or Input.is_action_just_pressed("Down") or\
		Input.is_action_just_pressed("Left")  or Input.is_action_just_pressed("Right") or\
		Input.is_action_just_released("Up")   or Input.is_action_just_released("Down") or\
		Input.is_action_just_released("Left") or Input.is_action_just_released("Right")
	var joystick := Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Down", "Up"))
	match joystick:
		Vector2(0, 0):   modifier_quality = Quality.Enum.UNKNOWN
		Vector2(0, 1):   modifier_quality = Quality.Enum.DOMINANT_7
		Vector2(-1, 0):  modifier_quality = Quality.Enum.DIMINISHED
		Vector2(1, 0):   modifier_quality = Quality.Enum.AUGMENTED
		_:               modifier_quality = Quality.Enum.UNKNOWN
	if joystick_moved:
		for i in range(7):
			if i in held_action_indexes:
				var chord : Chord = AudioEngine.key.get_chords()[i]
				if modifier_quality != Quality.Enum.UNKNOWN:
					chord.quality = modifier_quality
				print(chord.get_notes())
				var voice : Voice = VoiceBuilder.chord_to_voice(chord, AudioEngine.envelope, AudioEngine.voice_properties)
				AudioEngine.voice_manager.set_voice_oscillators(i, voice.oscillators)
