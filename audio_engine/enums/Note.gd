class_name Note
enum {
	C = 0,
	Cs = 1,
	D = 2,
	Ds = 3,
	E = 4,
	F = 5,
	Fs = 6,
	G = 7,
	Gs = 8,
	A = 9,
	As = 10,
	B = 11
}

static func to_frequency(note: int, octave: int) -> float:
	var midi := note + (octave + 1) * 12
	return 440.0 * pow(2.0, (midi - 69) / 12.0)
