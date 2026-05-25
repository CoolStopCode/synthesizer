extends Node

# -----------------------------
# MUSIC THEORY CONFIG
# -----------------------------

const KEY_ROOT := Note.C

# You can swap this for any mode later
const SCALE_INTERVALS := [0, 2, 3, 5, 7, 8, 10] # natural minor

# -----------------------------
# STATE
# -----------------------------

var held_actions: Array[String] = []

var scale_notes: Array[int] = []
var scale_chords: Array[int] = []

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
	for i in range(7):
		var action := "Key%d" % (i + 1)

		if Input.is_action_just_pressed(action):
			held_actions.erase(action)
			held_actions.append(action)
			rebuild_active_chord()

		if Input.is_action_just_released(action):
			held_actions.erase(action)
			rebuild_active_chord()

# -----------------------------
# SCALE BUILDING
# -----------------------------

func rebuild_scale() -> void:
	scale_notes.clear()
	scale_chords.clear()

	# Build scale notes
	for interval in SCALE_INTERVALS:
		scale_notes.append((KEY_ROOT + interval) % 12)

	# Build diatonic chord qualities
	for i in range(scale_notes.size()):
		var root := scale_notes[i]
		var third := scale_notes[(i + 2) % 7]
		var fifth := scale_notes[(i + 4) % 7]

		var interval_3 := (third - root + 12) % 12
		var interval_5 := (fifth - root + 12) % 12

		if interval_3 == 4 and interval_5 == 7:
			scale_chords.append(ChordType.MAJOR)

		elif interval_3 == 3 and interval_5 == 7:
			scale_chords.append(ChordType.MINOR)

		elif interval_3 == 3 and interval_5 == 6:
			scale_chords.append(ChordType.DIMINISHED)

		else:
			scale_chords.append(ChordType.MAJOR)

# -----------------------------
# CHORD LOGIC
# -----------------------------

func rebuild_active_chord() -> void:
	if held_actions.is_empty():
		AudioEngine.wave_generator.active_chord = null
		return

	var latest := held_actions[-1]
	var degree := int(latest.trim_prefix("Key")) - 1

	var chord := Chord.new()
	chord.root = scale_notes[degree]
	chord.octave = 4
	chord.type = scale_chords[degree]

	chord.build_voices()

	AudioEngine.wave_generator.active_chord = chord
