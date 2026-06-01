class_name Key
extends Resource

@export var root : Note
@export var scale : Scale.Enum

func get_notes() -> Array[Note]:
	var intervals = Scale.INTERVALS[scale]
	var root_midi = root.to_midi()

	var result: Array[Note] = []
	for i in intervals:
		result.append(Note.from_midi(root_midi + i))

	return result

func get_chords(shift : int = 0, sevenths : bool = false) -> Array[Chord]:
	var intervals : Array = Scale.INTERVALS[scale]
	var diatonic_qualities := Scale.get_diatonic_qualities(scale, sevenths)
	var root_midi := root.to_midi()
	
	var chords: Array[Chord] = []
	for i in range(intervals.size()):
		var chord = Chord.new()

		var chord_root_midi = root_midi + intervals[i]

		chord.root = Note.from_midi(chord_root_midi)
		chord.quality = diatonic_qualities[i]

		chords.append(chord)

	return chords
