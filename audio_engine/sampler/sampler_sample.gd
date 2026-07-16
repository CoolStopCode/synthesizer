class_name Sampler_Sample
extends Resource

@export var audio_stream : AudioStreamWAV

var decoded_samples : PackedFloat32Array

func decode_stream() -> void:
	var data := audio_stream.data
	var count := data.size() / 2  # 16-bit samples = 2 bytes each
	decoded_samples = PackedFloat32Array()
	decoded_samples.resize(count)
	for i in count:
		var byte_index := i * 2
		var low := data[byte_index]
		var high := data[byte_index + 1]
		var sample := low | (high << 8)
		if sample >= 32768:
			sample -= 65536
		decoded_samples[i] = sample / 32768.0

func get_sample_rate() -> float:
	return audio_stream.mix_rate

func get_sample_count() -> int:
	return audio_stream.data.size()

func get_sample(index: int) -> float:
	var byte_index := index * 2

	var low := audio_stream.data[byte_index]
	var high := audio_stream.data[byte_index + 1]

	var sample := low | (high << 8)

	if sample >= 32768:
		sample -= 65536

	return sample / 32768.0

func get_autocorrelation(lag : int, window_start : int, window_end : int) -> float:
	var end : int = min(window_end, get_sample_count())
	
	var sum := 0.0
	var count := 0
	
	for i in range(window_start + lag, end):
		sum += get_sample(i) * get_sample(i - lag)
		count += 1
	
	var normalized_autocorrelation := sum / count
	return normalized_autocorrelation

func get_frequency(window_start : int, window_end : int) -> float:
	const MIN_FREQUENCY := 80.0
	const MAX_FREQUENCY := 1000.0
	
	var min_lag := int(get_sample_rate() / MAX_FREQUENCY)
	var max_lag := int(get_sample_rate() / MIN_FREQUENCY)
	
	var autocorrelations := PackedFloat32Array()
	autocorrelations.resize(max_lag - min_lag + 1)
	
	var end : int = min(window_end, decoded_samples.size())
	for lag in range(min_lag, max_lag + 1):
		var sum := 0.0
		var count := 0
		for i in range(window_start + lag, end):
			sum += decoded_samples[i] * decoded_samples[i - lag]
			count += 1
		autocorrelations[lag - min_lag] = (sum / count) if count > 0 else 0.0
	
	var start_index : int
	for i in range(1, autocorrelations.size() - 1):
		if autocorrelations[i] >= autocorrelations[i - 1]:
			start_index = i
			break
	
	var first_peak_lag : int
	for j in range(start_index, autocorrelations.size() - 1):
		if      autocorrelations[j] > autocorrelations[j - 1] and\
				autocorrelations[j] > autocorrelations[j + 1]:
			first_peak_lag = j + min_lag
			break
	
	
	if first_peak_lag == 0:
		return 0.0
	return get_sample_rate() / first_peak_lag

func get_start() -> float:
	return 0.0
