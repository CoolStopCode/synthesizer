class_name SamplerSample
extends Resource

@export var audio_stream : AudioStreamWAV

func decode_stream(byte_data : PackedByteArray) -> PackedFloat32Array:
	var is_stereo : bool = audio_stream.stereo
	var format : AudioStreamWAV.Format = audio_stream.format
	
	match format:
		AudioStreamWAV.FORMAT_16_BITS:
			var sample_count : int = byte_data.size() / 2
			var decoded : PackedFloat32Array
			decoded.resize(sample_count)

			for i in range(sample_count):
				var byte_index : int = i * 2
				var low : int = byte_data[byte_index]
				var high : int = byte_data[byte_index + 1]
				var sample : int = low | (high << 8)
				if sample >= 32768:
					sample -= 65536
				decoded[i] = sample / 32768.0

			return decoded
		
		AudioStreamWAV.FORMAT_8_BITS:
			var sample_count : int = byte_data.size()
			var decoded : PackedFloat32Array
			decoded.resize(sample_count)
			
			for i in range(sample_count):
				decoded[i] = byte_data[i]
			
			return decoded
	
	return []

func downsample(samples : PackedFloat32Array, decimation_factor : int) -> PackedFloat32Array:
	var new_size : int = ceil(float(samples.size()) / decimation_factor)
	var downsampled : PackedFloat32Array
	downsampled.resize(new_size)

	for i in range(new_size):
		downsampled[i] = samples[i * decimation_factor]

	return downsampled

func low_pass_filter(samples : PackedFloat32Array, sample_rate : float, cutoff : float) -> PackedFloat32Array:
	var filtered : PackedFloat32Array
	filtered.resize(samples.size())

	var response_time : float = 1.0 / (TAU * cutoff)
	var delta : float = 1.0 / sample_rate
	var smoothing_factor : float = delta / (response_time + delta)
	
	for i in range(1, samples.size()):
		filtered[i] = filtered[i - 1] + smoothing_factor * (samples[i] - filtered[i - 1])

	return filtered

func hann_window(samples : PackedFloat32Array) -> PackedFloat32Array:
	var sample_count : int = samples.size()
	var windowed : PackedFloat32Array
	windowed.resize(sample_count)
	
	for i in range(sample_count):
		var multiplier : float = 0.5 - 0.5 * cos(TAU * i / (sample_count - 1))
		windowed[i] = samples[i] * multiplier
	
	return windowed





func normalized_square_difference(samples : PackedFloat32Array, max_lag : int) -> PackedFloat32Array:
	var sample_count : int = samples.size()
	
	var result : PackedFloat32Array
	result.resize(max_lag)
	
	var square_prefix : PackedFloat32Array
	square_prefix.resize(sample_count + 1)
	
	square_prefix[0] = 0.0
	for i in range(1, sample_count + 1):
		square_prefix[i] = square_prefix[i - 1] + samples[i - 1] * samples[i - 1]
	
	for i in range(max_lag):
		var window : int = sample_count - i
		var autocorrelation : float = 0.0
		for j in range(window):
			autocorrelation += samples[j] * samples[j + i]
		
		var sum_left : float = square_prefix[window]
		var sum_right : float = square_prefix[sample_count] - square_prefix[i]
		var energy : float = sum_left + sum_right
		
		if is_zero_approx(energy):
			result[i] = 0.0
		else:
			result[i] = (2.0 * autocorrelation) / energy
	
	return result

func parabolic_interpolation(values : PackedFloat32Array, index : int) -> float:
	var left : float = values[index - 1]
	var center : float = values[index]
	var right : float = values[index + 1]
	
	var denominator : float = left - 2.0 * center + right

	if is_zero_approx(denominator):
		return float(index)

	var delta : float = 0.5 * (left - right) / denominator
	return float(index) + delta

func key_maximum(values : PackedFloat32Array, threshold : float) -> float:
	var value_count : int = values.size()
	
	var start_search_index : int = -1
	for i in range(1, value_count): # Skip past first peak
		if values[i] < 0.0 and values[i - 1] >= 0.0:
			start_search_index = i
			break
	if start_search_index == -1: return -1.0
	
	var candidates : Array[int] = []
	for i in range(start_search_index, value_count - 1):
		if values[i] < 0.0:
			continue
		if values[i] >= values[i - 1] and values[i] > values[i + 1]:
			candidates.append(i)
	if candidates.is_empty(): return -1.0
	
	var highest_candidate : float = -INF
	for candidate in candidates:
		highest_candidate = max(highest_candidate, values[candidate])
	
	for candidate in candidates:
		if values[candidate] >= threshold * highest_candidate:
			return parabolic_interpolation(values, candidate)
	
	return -1.0




func get_frequencies(
	window_start : int,
	window_end : int,
	minimum_frequency : float = 20.0,
	maximum_frequency : float = 2000.0,
	decimation_factor : int = 4,
	peak_threshold : float = 0.85
) -> Array[float]:
	var downsampled_sample_rate : float = audio_stream.mix_rate / decimation_factor
	
	var decoded_stream : PackedFloat32Array = decode_stream(audio_stream.data)
	#var filtered_stream : PackedFloat32Array = low_pass_filter(decoded_stream, audio_stream.mix_rate, downsampled_sample_rate * 0.45)
	var downsampled_stream : PackedFloat32Array = downsample(decoded_stream, decimation_factor)

	var downsampled_start : int = window_start / decimation_factor
	var downsampled_end : int = window_end / decimation_factor
	var window_length : int = downsampled_end - downsampled_start
	var hop_length : int = window_length / 2

	var max_lag : int = min(int(downsampled_sample_rate / minimum_frequency), window_length - 1)

	var results : Array[float] = []
	var slice_count : int = (downsampled_stream.size() - window_length) / hop_length + 1

	for i in range(slice_count):
		var slice_start : int = i * hop_length
		var slice : PackedFloat32Array = downsampled_stream.slice(slice_start, slice_start + window_length)
		#var hann_slice : PackedFloat32Array = hann_window(slice)
		var nsdf_slice : PackedFloat32Array = normalized_square_difference(slice, max_lag)
		
		var maximum : float = key_maximum(nsdf_slice, peak_threshold)
		var frequency : float = downsampled_sample_rate / maximum

		results.append(frequency)

	return results

func estimate_root_frequency(
	window_start : int,
	window_end : int,
) -> float:
	var frames : Array[float] = get_frequencies(window_start, window_end, 20.0, 2000.0, 4, 0.03)
	frames.sort()
	
	var median_frequency : float = frames[frames.size() / 2]
	return median_frequency
