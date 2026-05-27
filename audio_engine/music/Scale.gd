class_name Scale

enum Enum {
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
	Enum.MAJOR: [0,2,4,5,7,9,11],
	Enum.NATURAL_MINOR: [0,2,3,5,7,8,10],
	Enum.DORIAN: [0,2,3,5,7,9,10],
	Enum.PHRYGIAN: [0,1,3,5,7,8,10],
	Enum.LYDIAN: [0,2,4,6,7,9,11],
	Enum.MIXOLYDIAN: [0,2,4,5,7,9,10],
	Enum.MELODIC_MINOR: [0,2,3,5,7,9,11],
	Enum.HARMONIC_MINOR: [0,2,3,5,7,8,11],
	Enum.LOCRIAN: [0,1,3,5,6,8,10]
}

static func get_diatonic_qualities(scale: Scale.Enum, sevenths : bool) -> Array[Quality.Enum]:
	var interval = INTERVALS[scale]
	var size = interval.size()
	
	var qualities : Array[Quality.Enum] = []
	for degree in range(size):
		var root = interval[degree]
		var intervals : Array[int]

		# THIRD
		var third = interval[(degree + 2) % size]
		if degree + 2 >= size:
			third += 12
		intervals.append(third - root)

		# FIFTH
		var fifth = interval[(degree + 4) % size]
		if degree + 4 >= size:
			fifth += 12
		intervals.append(fifth - root)

		# SEVENTH
		if sevenths:
			var seventh = interval[(degree + 6) % size]
			if degree + 6 >= size:
				seventh += 12
			intervals.append(seventh - root)

		qualities.append(
			Quality.from_intervals(intervals)
		)

	return qualities
