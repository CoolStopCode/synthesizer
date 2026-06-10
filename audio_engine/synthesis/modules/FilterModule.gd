class_name GDFilterModule
extends GDModule

enum FilterType {
	LOW_PASS,
	HIGH_PASS,
	BAND_PASS
}

@export_category("SETTINGS")
@export var filter_type: FilterType = FilterType.LOW_PASS

@export_category("PORTS")
@export var IN_audio: GDFloatPort
@export var IN_cutoff: GDFloatPort
@export var IN_resonance: GDFloatPort
@export var OUT_output: GDFloatPort

# PRIVATE
var previous: float = 0.0

func _init() -> void:
	inputs = [
		IN_audio,
		IN_cutoff,
		IN_resonance
	]
	outputs = [
		OUT_output
	]

func process(delta: float) -> void:
	var input_sample := IN_audio.value
	var cutoff := IN_cutoff.value
	var resonance := IN_resonance.value

	var alpha : float = clamp(cutoff * delta, 0.0, 1.0)

	var resonant_input := input_sample + (input_sample - previous) * resonance

	previous += (resonant_input - previous) * alpha

	var low_pass := previous
	var high_pass := input_sample - low_pass
	var band_pass := low_pass - high_pass # approximation

	match filter_type:
		FilterType.LOW_PASS:
			OUT_output.value = low_pass

		FilterType.HIGH_PASS:
			OUT_output.value = high_pass

		FilterType.BAND_PASS:
			OUT_output.value = band_pass
