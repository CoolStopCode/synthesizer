extends Node

var active_index: int = -1  # only ONE key can be active

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	for i in range(7):
		var action := "Key%d" % (i + 1)

		if Input.is_action_just_pressed(action):
			# If another key is already active, turn it off first
			if active_index != -1 and active_index != i:
				AudioEngine.voice_manager.voice_off(active_index)

			active_index = i
			AudioEngine.voice_manager.voice_on(i)

		if Input.is_action_just_released(action):
			# Only turn off if this is the currently active key
			if active_index == i:
				AudioEngine.voice_manager.voice_off(i)
				active_index = -1

	# joystick modifier stays the same idea, but now only applies to ONE chord
	if active_index != -1:
		var joystick := Vector2(
			Input.get_axis("Left", "Right"),
			Input.get_axis("Down", "Up")
		)

		var modifier_quality : Quality.Enum = Quality.Enum.UNKNOWN

		match joystick:
			Vector2(0, 1):   modifier_quality = Quality.Enum.DOMINANT_7
			Vector2(-1, 0):  modifier_quality = Quality.Enum.DIMINISHED
			Vector2(1, 0):   modifier_quality = Quality.Enum.AUGMENTED
			_: pass

		if modifier_quality != Quality.Enum.UNKNOWN:
			var chord: Chord = AudioEngine.key.get_chords()[active_index]
			chord.quality = modifier_quality

			var voice: Voice = VoiceBuilder.chord_to_voice(
				chord,
				AudioEngine.envelope,
				AudioEngine.voice_properties
			)

			AudioEngine.voice_manager.set_voice_oscillators(active_index, voice.oscillators)
