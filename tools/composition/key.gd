class_name CompositionKey
extends Resource

enum Modus {
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
	Modus.MAJOR: [0,2,4,5,7,9,11],
	Modus.NATURAL_MINOR: [0,2,3,5,7,8,10],
	Modus.DORIAN: [0,2,3,5,7,9,10],
	Modus.PHRYGIAN: [0,1,3,5,7,8,10],
	Modus.LYDIAN: [0,2,4,6,7,9,11],
	Modus.MIXOLYDIAN: [0,2,4,5,7,9,10],
	Modus.MELODIC_MINOR: [0,2,3,5,7,9,11],
	Modus.HARMONIC_MINOR: [0,2,3,5,7,8,11],
	Modus.LOCRIAN: [0,1,3,5,6,8,10]
}

@export var root : CompositionNote
@export var modus : Modus

func build_scale() -> TonalScale:
	var scale := TonalScale.new()
	scale.root = root.to_semitone()
	scale.intervals.assign(INTERVALS[modus])
	return scale
