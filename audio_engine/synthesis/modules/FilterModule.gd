class_name FilterModule
extends Module

enum FilterType {
	LOW_PASS,
	HIGH_PASS,
	BAND_PASS
}

# SETTINGS
var filter_type: FilterType = FilterType.LOW_PASS

# PORTS
var audio_in: FloatPortIn
var cutoff_in: FloatPortIn
var resonance_in: FloatPortIn
var output_out: FloatPortOut

# PRIVATE
var previous: float = 0.0

func _init() -> void:
	audio_in = FloatPortIn.new()
	cutoff_in = FloatPortIn.new()
	resonance_in = FloatPortIn.new()
	output_out = FloatPortOut.new()

	inputs = [
		audio_in,
		cutoff_in,
		resonance_in
	]
	outputs = [output_out]

func process(delta: float) -> void:
	var input_sample := audio_in.get_value()
	var cutoff := cutoff_in.get_value()
	var resonance := resonance_in.get_value()

	var alpha : float = clamp(cutoff * delta, 0.0, 1.0)

	var resonant_input := input_sample + (input_sample - previous) * resonance

	previous += (resonant_input - previous) * alpha

	var low_pass := previous
	var high_pass := input_sample - low_pass
	var band_pass := low_pass - high_pass # approximation

	match filter_type:
		FilterType.LOW_PASS:
			output_out.set_value(low_pass)

		FilterType.HIGH_PASS:
			output_out.set_value(high_pass)

		FilterType.BAND_PASS:
			output_out.set_value(band_pass)
