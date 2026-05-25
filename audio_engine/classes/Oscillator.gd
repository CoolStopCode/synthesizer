class_name Oscillator

static func evaluate(waveform: int, phase: float) -> float:
	var p := phase
	p = p - floor(p) # fract(p)

	match waveform:
		Waveform.SINE:
			return sin(p * TAU)

		Waveform.SQUARE:
			return sign(sin(p * TAU))

		Waveform.SAWTOOTH:
			return (p * 2.0) - 1.0

		Waveform.TRIANGLE:
			return abs(p - 0.5) * 4.0 - 1.0

		Waveform.PULSE:
			return 1.0 if (p < 0.25) else -1.0

		Waveform.SOFT_SINE:
			var s := sin(p * TAU)
			return s * abs(s)

		Waveform.HALF_RECT_SINE:
			return max(0.0, sin(p * TAU))

		Waveform.FULL_RECT_SINE:
			return abs(sin(p * TAU))

		Waveform.NOISE:
			return randf_range(-1.0, 1.0)

		Waveform.SAMPLE_HOLD:
			var steps := 12.0
			var stepped = floor(p * steps) / steps
			return randf_range(-1.0, 1.0) * stepped

		Waveform.EXP_SAW:
			return (pow(2.0, p) - 1.0) * 2.0 - 1.0

		Waveform.LOG_SAW:
			return (log(1.0 + 9.0 * p) / log(10.0)) * 2.0 - 1.0

		Waveform.PULSE_TRAIN:
			var rp = (p * 8.0) - floor(p * 8.0)
			return 1.0 if (rp < 0.1) else -1.0

		Waveform.FM_SINE:
			return sin(p * TAU + sin(p * TAU * 2.0) * 0.5)

	return 0.0
