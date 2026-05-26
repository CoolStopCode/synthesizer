extends Node

# -----------------------------
# MUSIC THEORY CONFIG
# -----------------------------
const KEY_ROOT := Note.Enum.C
const SCALE_INTERVALS := [0, 2, 3, 5, 7, 8, 10] # natural minor

# -----------------------------
# STATE
# -----------------------------
var held_actions: Array[String] = []

var scale_notes: Array[int] = []
var scale_chords: Array[int] = []

# Track currently playing note IDs
var active_note_ids: Array[int] = []

# -----------------------------
# LIFECYCLE
# -----------------------------
func _ready() -> void:
	rebuild_scale()

func _process(_delta: float) -> void:
	handle_input()

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
# SYNTH COORDINATION LAYER
# -----------------------------
func update_synthesizer_voices() -> void:
	# Stop old notes
	for note_id in active_note_ids:
		AudioEngine.voice_manager.note_off(note_id)

	active_note_ids.clear()

	# Nothing held
	if held_actions.is_empty():
		return

	# Latest held key wins
	var latest := held_actions[-1]
	var degree := int(latest.trim_prefix("Key")) - 1

	# Build chord
	var chord := Chord.new()
	chord.root = Note.from_midi(scale_notes[degree] + (6 * 12))
	chord.type = scale_chords[degree] as ChordType.Enum

	# Play notes
	for note in chord.get_notes():
		var midi := note.to_midi()
		print(note.to_string_name())
		var frequency := note.to_frequency()

		active_note_ids.append(midi)

		AudioEngine.voice_manager.note_on(
			frequency,
			midi
		)
