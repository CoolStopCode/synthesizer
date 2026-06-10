class_name FilterModule
extends Module

enum FilterType {
	LOW_PASS,
	HIGH_PASS,
	BAND_PASS
}

@export_category("SETTINGS")
@export var filter_type: FilterType = FilterType.LOW_PASS

@export_category("PORTS")
@export var audio_in: FloatPort
@export var cutoff_in: FloatPort
@export var resonance_in: FloatPort
@export var output_out: FloatPort

# PRIVATE
var previous: float = 0.0

func _init() -> void:
	inputs = [
		audio_in,
		cutoff_in,
		resonance_in
	]
	outputs = [
		output_out
	]

func process(delta: float) -> void:
	var input_sample := audio_in.value
	var cutoff := cutoff_in.value
	var resonance := resonance_in.value

	var alpha : float = clamp(cutoff * delta, 0.0, 1.0)

	var resonant_input := input_sample + (input_sample - previous) * resonance

	previous += (resonant_input - previous) * alpha

	var low_pass := previous
	var high_pass := input_sample - low_pass
	var band_pass := low_pass - high_pass # approximation

	match filter_type:
		FilterType.LOW_PASS:
			output_out.value = low_pass

		FilterType.HIGH_PASS:
			output_out.value = high_pass

		FilterType.BAND_PASS:
			output_out.value = band_pass
