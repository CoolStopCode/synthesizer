class_name Scale
extends Resource

@export var mode : Mode

enum Mode {
	MAJOR,
	NATURAL_MINOR,
	DORIAN,
	PHRYGIAN,
	LYDIAN,
	MIXOLYDIAN,
	MELODIC_MINOR,
	HARMONIC_MINOR,
	LOCRIAN
}

const INTERVALS : Dictionary = {
	Mode.MAJOR: [0,2,4,5,7,9,11],
	Mode.NATURAL_MINOR: [0,2,3,5,7,8,10],
	Mode.DORIAN: [0,2,3,5,7,9,10],
	Mode.PHRYGIAN: [0,1,3,5,7,8,10],
	Mode.LYDIAN: [0,2,4,6,7,9,11],
	Mode.MIXOLYDIAN: [0,2,4,5,7,9,10],
	Mode.MELODIC_MINOR: [0,2,3,5,7,9,11],
	Mode.HARMONIC_MINOR: [0,2,3,5,7,8,11],
	Mode.LOCRIAN: [0,1,3,5,6,8,10]
}

func get_intervals() -> Array:
	return INTERVALS[mode]

func get_qualities(members : Array[int]) -> Array[Quality]:
	var intervals = INTERVALS[mode]
	var size = intervals.size()
	var qualities : Array[Quality] = []
	for degree in range(size):
		var root_interval = intervals[degree]
		var chord_intervals: Array[int] = []
		for member in members:
			var target_degree = member + degree
			var octave_shift = (target_degree / size) * 12
			var member_absolute_interval = intervals[target_degree % size] + octave_shift
			chord_intervals.append(member_absolute_interval - root_interval)
		var quality := Quality.from_intervals(chord_intervals)
		qualities.append(quality)
	return qualities
