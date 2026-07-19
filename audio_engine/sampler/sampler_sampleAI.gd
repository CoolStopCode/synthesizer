class_name Sampler_SampleAI
extends Resource

@export var audio_stream : AudioStreamWAV

# ---------------------------------------------------------
# Decoding / preprocessing
# ---------------------------------------------------------

func decode_stream(byte_data : PackedByteArray) -> PackedFloat32Array:
	# NOTE: this only handles 16-bit PCM. AudioStreamWAV can also store
	# 8-bit, IMA ADPCM, or QOA data - if your importer allows those,
	# branch on audio_stream.format here and decode accordingly.
	assert(audio_stream.format == AudioStreamWAV.FORMAT_16_BITS,
		"decode_stream currently only supports 16-bit PCM")

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

# Simple one-pole low-pass filter applied BEFORE decimation, so high
# frequencies don't alias down into the range we're trying to detect
# pitch in. cutoff should be roughly (new_sample_rate / 2).
func low_pass_filter(samples : PackedFloat32Array, sample_rate : float, cutoff : float) -> PackedFloat32Array:
	var filtered : PackedFloat32Array
	filtered.resize(samples.size())
	if samples.is_empty():
		return filtered

	var rc : float = 1.0 / (2.0 * PI * cutoff)
	var dt : float = 1.0 / sample_rate
	var alpha : float = dt / (rc + dt)

	filtered[0] = samples[0]
	for i in range(1, samples.size()):
		filtered[i] = filtered[i - 1] + alpha * (samples[i] - filtered[i - 1])

	return filtered

func downsample(samples : PackedFloat32Array, decimation_factor : int) -> PackedFloat32Array:
	var new_size : int = int(ceil(float(samples.size()) / decimation_factor))
	var downsampled : PackedFloat32Array
	downsampled.resize(new_size)

	for i in range(new_size):
		downsampled[i] = samples[i * decimation_factor]

	return downsampled

func apply_hann_window(samples : PackedFloat32Array) -> PackedFloat32Array:
	var n : int = samples.size()
	var windowed : PackedFloat32Array
	windowed.resize(n)
	if n <= 1:
		return samples

	for i in range(n):
		var w : float = 0.5 - 0.5 * cos(TAU * i / (n - 1))
		windowed[i] = samples[i] * w

	return windowed

# ---------------------------------------------------------
# MPM core: Normalized Square Difference Function
# ---------------------------------------------------------

# NSDF(tau) = 2 * ACF(tau) / m(tau)
#   ACF(tau) = sum_j x[j] * x[j+tau]                  (autocorrelation)
#   m(tau)   = sum_j x[j]^2 + x[j+tau]^2               (energy term)
# Bounded to [-1, 1]; a clean periodic signal gives NSDF(0) == 1.0 and
# a strong peak back near 1.0 at tau == the true period.
func nsdf(samples : PackedFloat32Array, max_lag : int) -> PackedFloat32Array:
	var n : int = samples.size()
	max_lag = min(max_lag, n - 1)

	var result : PackedFloat32Array
	result.resize(max_lag)

	# Prefix sum of squares so m(tau) is O(1) per lag instead of an
	# extra O(n) re-summation every time.
	var square_prefix : PackedFloat32Array
	square_prefix.resize(n + 1)
	square_prefix[0] = 0.0
	for i in range(n):
		square_prefix[i + 1] = square_prefix[i] + samples[i] * samples[i]

	for tau in range(max_lag):
		var window : int = n - tau
		var acf : float = 0.0
		for j in range(window):
			acf += samples[j] * samples[j + tau]

		var sum_left : float = square_prefix[window]
		var sum_right : float = square_prefix[n] - square_prefix[tau]
		var m : float = sum_left + sum_right

		result[tau] = 0.0 if is_zero_approx(m) else (2.0 * acf) / m

	return result

# Returns (interpolated_lag, interpolated_value).
func parabolic_interpolation(values : PackedFloat32Array, index : int) -> Vector2:
	if index <= 0 or index >= values.size() - 1:
		return Vector2(index, values[index])

	var left : float = values[index - 1]
	var center : float = values[index]
	var right : float = values[index + 1]
	var denominator : float = left - 2.0 * center + right

	if is_zero_approx(denominator):
		return Vector2(index, center)

	var offset : float = 0.5 * (left - right) / denominator
	var interpolated_value : float = center - 0.25 * (left - right) * offset
	return Vector2(index + offset, interpolated_value)

# "Key maximum" peak picking (McLeod & Wyvill, 2005).
# Skip past the always-present peak at tau=0 by waiting for the first
# negative-going zero crossing. Collect every local maximum after
# that as a candidate. Then pick the FIRST candidate within
# `threshold` of the tallest candidate found - not just the tallest
# one outright. This is what fixes YIN-style octave errors: a
# harmonic peak might be taller, but the fundamental's peak usually
# still clears the threshold and comes first.
func pick_pitch_lag(values : PackedFloat32Array, threshold : float = 0.85) -> Vector2:
	var candidate_indices : Array[int] = []
	var n : int = values.size()
	var i : int = 0

	while i < n - 1 and values[i] > 0.0:
		i += 1

	while i < n - 1:
		if values[i] < 0.0:
			i += 1
			continue
		var found_max : int = i
		while i < n - 1 and values[i + 1] > values[i]:
			i += 1
			found_max = i
		candidate_indices.append(found_max)
		i += 1
		while i < n - 1 and values[i] > 0.0 and values[i] < values[i - 1]:
			i += 1

	if candidate_indices.is_empty():
		return Vector2(-1, 0.0)

	var highest_value : float = -INF
	for idx in candidate_indices:
		highest_value = max(highest_value, values[idx])

	for idx in candidate_indices:
		if values[idx] >= threshold * highest_value:
			return parabolic_interpolation(values, idx)

	return Vector2(-1, 0.0)

# ---------------------------------------------------------
# Public API
# ---------------------------------------------------------

# One {frequency, confidence} dict per analysis window, hopping
# through the sample. confidence is the NSDF peak height (0-1);
# treat frames near 0 as "couldn't find a pitch here".
func get_frequencies(
	window_start : int,
	window_end : int,
	minimum_frequency : float = 20.0,
	maximum_frequency : float = 2000.0,
	decimation_factor : int = 4,
	peak_threshold : float = 0.85
) -> Array[Dictionary]:
	var full_stream : PackedFloat32Array = decode_stream(audio_stream.data)

	var target_rate : float = audio_stream.mix_rate / float(decimation_factor)
	var filtered : PackedFloat32Array = low_pass_filter(
		full_stream, audio_stream.mix_rate, target_rate * 0.45
	)
	var decoded_stream : PackedFloat32Array = downsample(filtered, decimation_factor)

	var window_length : int = int((window_end - window_start) / float(decimation_factor))
	var hop_length : int = window_length / 2

	var max_lag : int = int(target_rate / minimum_frequency)
	max_lag = min(max_lag, window_length - 1)

	var results : Array[Dictionary] = []

	if window_length <= 0 or decoded_stream.size() < window_length:
		return results

	var slice_count : int = (decoded_stream.size() - window_length) / hop_length + 1

	for i in range(slice_count):
		var slice_start : int = i * hop_length
		var raw_slice : PackedFloat32Array = decoded_stream.slice(slice_start, slice_start + window_length)
		var slice : PackedFloat32Array = apply_hann_window(raw_slice)

		var slice_nsdf : PackedFloat32Array = nsdf(slice, max_lag)
		var pick : Vector2 = pick_pitch_lag(slice_nsdf, peak_threshold)

		if pick.x <= 0.0:
			results.append({ "frequency": 0.0, "confidence": 0.0 })
			continue

		var frequency : float = target_rate / pick.x
		if frequency < minimum_frequency or frequency > maximum_frequency:
			results.append({ "frequency": 0.0, "confidence": 0.0 })
			continue

		results.append({ "frequency": frequency, "confidence": pick.y })

	return results

# Collapses per-window estimates into a single root frequency for the
# whole sample, ignoring low-confidence (likely non-tonal / noisy)
# frames. Use this as the value you feed into your chord/transpose
# logic; check "is_tonal" to decide whether to trust it or fall back
# to a default root note / manual override.
func estimate_root_frequency(
	window_start : int,
	window_end : int,
	confidence_floor : float = 0.6
) -> Dictionary:
	var frames : Array[Dictionary] = get_frequencies(window_start, window_end)

	var good_frequencies : Array[float] = []
	var total_confidence : float = 0.0

	for frame in frames:
		if frame["confidence"] >= confidence_floor and frame["frequency"] > 0.0:
			good_frequencies.append(frame["frequency"])
			total_confidence += frame["confidence"]

	if good_frequencies.is_empty():
		return { "frequency": 0.0, "confidence": 0.0, "is_tonal": false }

	good_frequencies.sort()
	var median_frequency : float = good_frequencies[good_frequencies.size() / 2]
	var average_confidence : float = total_confidence / good_frequencies.size()

	return {
		"frequency": median_frequency,
		"confidence": average_confidence,
		"is_tonal": average_confidence >= confidence_floor
	}
