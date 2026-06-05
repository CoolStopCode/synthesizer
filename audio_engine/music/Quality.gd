class_name Quality
extends Resource

@export var type : Type

func _init(_type : Type) -> void:
	type = _type

enum Type {
	MAJOR,
	MINOR,
	DIMINISHED,
	AUGMENTED,

	MAJOR_7,
	MINOR_7,
	DOMINANT_7,
	HALF_DIMINISHED_7,
	DIMINISHED_7,
	AUGMENTED_7,
	
	SUSPENDED_4,

	UNKNOWN
}

const INTERVALS = {
	Type.MAJOR: [0, 4, 7],
	Type.MINOR: [0, 3, 7],
	Type.DIMINISHED: [0, 3, 6],
	Type.AUGMENTED: [0, 4, 8],
	Type.MAJOR_7: [0, 4, 7, 11],
	Type.MINOR_7: [0, 3, 7, 10],
	Type.DOMINANT_7: [0, 4, 7, 10],
	Type.HALF_DIMINISHED_7: [0, 3, 6, 10],
	Type.DIMINISHED_7: [0, 3, 6, 9],
	Type.AUGMENTED_7: [0, 4, 8, 10],
	Type.SUSPENDED_4: [0, 5, 7],
	
	Type.UNKNOWN: [],
}

func to_intervals() -> Array:
	return INTERVALS[type]


static func from_intervals(intervals: Array[int]) -> Quality:
	for quality in INTERVALS:
		var quality_intervals = INTERVALS[quality]

		if quality_intervals == intervals:
			return Quality.new(quality)

	return Quality.new(Type.UNKNOWN)
