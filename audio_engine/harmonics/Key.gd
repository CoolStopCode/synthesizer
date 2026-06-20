class_name Key
extends Resource

@export var root : Note
@export var scale : Scale

func get_notes() -> Array[Note]:
	var intervals = Scale.INTERVALS[scale]
	var root_midi = root.to_midi()

	var result: Array[Note] = []
	for i in intervals:
		result.append(Note.from_midi(root_midi + i))

	return result

func get_chords() -> Array[Chord]:
	var intervals : Array = scale.get_intervals()
	var qualities := scale.get_qualities([0, 2, 4])
	var root_midi := root.to_midi()
	
	var chords: Array[Chord] = []
	for i in range(intervals.size()):
		var chord = Chord.new()

		var chord_root_midi = root_midi + intervals[i]

		chord.root = Note.from_midi(chord_root_midi)
		chord.quality = qualities[i]

		chords.append(chord)

	return chords
