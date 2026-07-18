class_name Sampler_Sample
extends Resource

@export var audio_stream : AudioStreamWAV

func downsample_stream(byte_data : PackedByteArray, decimation_factor : int) -> PackedByteArray:
	var original_size : int = byte_data.size() / 2
 
	var new_size : int = int(ceil(float(original_size) / decimation_factor))
	var downsampled : PackedByteArray
	downsampled.resize(new_size * 2)
 
	for i in range(new_size):
		var source_index : int = i * decimation_factor * 2
		var destination_index : int = i * 2
		downsampled[destination_index] = byte_data[source_index]
	
	return downsampled
 
func decode_stream(byte_data : PackedByteArray) -> PackedFloat32Array:
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

func first_local_minimum_under_threshold(
	values : Array[float],
	threshold : float
) -> int:
	var start_index : int = 0
	var end_index : int = values.size()
	
	var start_minimum_check : int
	for threshold_check in range(start_index, end_index):
		if values[threshold_check] < threshold:
			start_minimum_check = threshold_check
			break
	
	for minimum_check in range(start_minimum_check + 1, end_index):
		if values[minimum_check] > values[minimum_check - 1]:
			return minimum_check - 1
	
	return -1

func parabolic_interpolation(left : float, center : float, right : float) -> float:
	var numerator : float = left - right
	var denominator : float = left - 2.0 * center + right
	if is_zero_approx(denominator): return 0.0
	
	return 0.5 * numerator / denominator

# Squared-difference function d(tau) for a single lag, computed over the
# first window_length samples of the given buffer. The buffer must be at
# least window_length + tau samples long.
func difference(samples : PackedFloat32Array, window_length : int, lag : int) -> float:
	var sum : float = 0.0
	for j in range(window_length - lag):
		var delta : float = samples[j] - samples[j + lag]
		sum += delta * delta

	return sum


# Cumulative Mean Normalized Difference Function. Returns an array indexed
# by lag (0..maximum_lag - 1); cmndf[0] is defined as 1.0 by convention.
func cmndf(samples : PackedFloat32Array, window_length : int, minimum_lag : int, maximum_lag : int) -> Array[float]:
	var result : Array[float] = []
	result.resize(maximum_lag)
	result[0] = 1.0

	var running_sum : float = 0.0
	for tau in range(1, maximum_lag):
		var d : float = difference(samples, window_length, tau)
		running_sum += d

		if is_zero_approx(running_sum):
			result[tau] = 1.0
		else:
			result[tau] = d * tau / running_sum

	return result

func get_frequencies(
	window_start : int, 
	window_end : int,
	minimum_frequency : float = 20.0,
	maximum_frequency : float = 8000.0,
	decimation_factor : int = 4,
	cmndf_threshold : float = 0.3
) -> Array[float]:
	var downsampled_bytes : PackedByteArray = downsample_stream(audio_stream.data, decimation_factor)
	var decoded_stream : PackedFloat32Array = decode_stream(downsampled_bytes)
	
	var frequencies : Array[float]
	
	var downsampled_sample_rate := audio_stream.mix_rate / decimation_factor
	var window_length : int = window_end - window_start

	var minimum_lag : int = int(downsampled_sample_rate / maximum_frequency)
	var maximum_lag : int = int(downsampled_sample_rate / minimum_frequency)

	var hop_length : int = window_length / 2
	var slice_count = (decoded_stream.size() - window_length) / hop_length + 1
	for i in range(slice_count):
		var slice_start : int = i * hop_length
		var slice : PackedFloat32Array = decoded_stream.slice(
			slice_start,
			slice_start + window_length
		)
		
		var stream_cmndf : Array[float] = cmndf(
			slice,
			window_length,
			minimum_lag,
			maximum_lag
		)
		
		var stream_flmut : int = first_local_minimum_under_threshold(
			stream_cmndf,
			cmndf_threshold
		)
		
		if stream_flmut == -1:
			frequencies.append(0.0)
			continue
		
		var fractional_offset : float = parabolic_interpolation(
			stream_cmndf[stream_flmut - 1],
			stream_cmndf[stream_flmut],
			stream_cmndf[stream_flmut + 1]
		)
		
		var estimated_lag : float = minimum_lag + stream_flmut + fractional_offset
		var estimated_frequency : float = (audio_stream.mix_rate / decimation_factor) / estimated_lag
		frequencies.append(estimated_frequency)

	return frequencies
