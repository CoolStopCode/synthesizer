extends Node

# -----------------------------
# MUSIC THEORY CONFIG
# -----------------------------
const KEY_ROOT := Note.Enum.A
const SCALE_INTERVALS := [0, 2, 3, 5, 7, 8, 10]

# -----------------------------
# STATE
# -----------------------------
var held_actions: Array[String] = []

var scale_notes: Array[int] = []
var scale_chords: Array[int] = []

var active_voice_indices: Array[int] = []

# -----------------------------
# LIFECYCLE
# -----------------------------
func _ready() -> void:
	rebuild_scale()
	build_voice_pool()

func _process(_delta: float) -> void:
	handle_input()

# -----------------------------
# VOICE POOL (STATIC)
# -----------------------------
func build_voice_pool() -> void:
	var voice_manager : VoiceManager = AudioEngine.voice_manager

	# Build ONE chord representing maximum polyphony (7 voices)
	var base_chord := Chord.new()
	base_chord.root = Note.from_midi(60) # placeholder root
	base_chord.type = ChordType.Enum.MAJOR

	# Create full voice pool once
	var voices: Array[Voice] = VoiceBuilder.chords_to_voices([base_chord])

	# If your builder only returns one voice per chord, expand it:
	voice_manager.build_voice_pool(voices)

# -----------------------------
# INPUT
# -----------------------------
func handle_input() -> void:
	var state_changed := false

	for i in range(7):
		var action := "Key%d" % (i + 1)

		if Input.is_action_just_pressed(action):
			held_actions.erase(action)
			held_actions.append(action)
			state_changed = true

		if Input.is_action_just_released(action):
			held_actions.erase(action)
			state_changed = true

	if state_changed:
		update_synthesizer_voices()

# -----------------------------
# SCALE BUILDING
# -----------------------------
func rebuild_scale() -> void:
	scale_notes.clear()
	scale_chords.clear()

	for interval in SCALE_INTERVALS:
		scale_notes.append((KEY_ROOT + interval) % 12)

	for i in range(scale_notes.size()):
		var root := scale_notes[i]
		var third := scale_notes[(i + 2) % 7]
		var fifth := scale_notes[(i + 4) % 7]

		var interval_3 := (third - root + 12) % 12
		var interval_5 := (fifth - root + 12) % 12

		if interval_3 == 4 and interval_5 == 7:
			scale_chords.append(ChordType.Enum.MAJOR)
		elif interval_3 == 3 and interval_5 == 7:
			scale_chords.append(ChordType.Enum.MINOR)
		elif interval_3 == 3 and interval_5 == 6:
			scale_chords.append(ChordType.Enum.DIMINISHED)
		else:
			scale_chords.append(ChordType.Enum.MAJOR)

# -----------------------------
# SYNTH COORDINATION
# -----------------------------
func update_synthesizer_voices() -> void:
	var voice_manager : VoiceManager = AudioEngine.voice_manager

	# turn off previous voices
	for i in active_voice_indices:
		voice_manager.voice_off(i)

	active_voice_indices.clear()

	if held_actions.is_empty():
		return

	var latest := held_actions[-1]
	var degree := int(latest.trim_prefix("Key")) - 1

	var chord := Chord.new()
	chord.root = Note.from_midi(scale_notes[degree] + (6 * 12))
	chord.type = scale_chords[degree] as ChordType.Enum

	# Convert chord -> voices (NO rebuilding pool)
	var voices := VoiceBuilder.chord_to_voice(chord)

	# IMPORTANT: assumes pool already exists and is same size mapping
	for i in range(voices.size()):
		voice_manager.voice_on(i)
		active_voice_indices.append(i)
