class_name Waveform

enum {
	SINE,
	SQUARE,
	SAWTOOTH,
	TRIANGLE,

	# basic variants
	PULSE,
	NOISE,
	SAMPLE_HOLD,

	# sine variants
	SOFT_SINE,
	HALF_RECT_SINE,
	FULL_RECT_SINE,

	# saw variants
	EXP_SAW,
	LOG_SAW,

	# pulse variants
	PULSE_TRAIN,

	# FM / complex
	FM_SINE
}
