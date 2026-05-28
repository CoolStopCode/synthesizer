class_name Quality

enum Enum {
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
	Quality.Enum.MAJOR: [0, 4, 7],
	Quality.Enum.MINOR: [0, 3, 7],
	Quality.Enum.DIMINISHED: [0, 3, 6],
	Quality.Enum.AUGMENTED: [0, 4, 8],
	Quality.Enum.MAJOR_7: [0, 4, 7, 11],
	Quality.Enum.MINOR_7: [0, 3, 7, 10],
	Quality.Enum.DOMINANT_7: [0, 4, 7, 10],
	Quality.Enum.HALF_DIMINISHED_7: [0, 3, 6, 10],
	Quality.Enum.DIMINISHED_7: [0, 3, 6, 9],
	Quality.Enum.AUGMENTED_7: [0, 4, 8, 10],
	Quality.Enum.SUSPENDED_4: [0, 5, 7],
	
	Quality.Enum.UNKNOWN: [],
}

static func from_intervals(intervals: Array[int]) -> Quality.Enum:
	for quality in INTERVALS:
		var quality_intervals = INTERVALS[quality]

		# Skip root (0)
		var compare : Array = quality_intervals.slice(1)

		if compare == intervals:
			return quality

	return Quality.Enum.UNKNOWN
