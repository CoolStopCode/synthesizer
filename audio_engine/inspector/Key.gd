class_name Key
extends Resource

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

@export var root : Note
@export var mode : Mode

func build_scale() -> Scale:
	var scale := Scale.new()
	scale.root = root.to_semitone()
	scale.intervals.assign(INTERVALS[mode])
	print(scale.intervals)
	return scale
