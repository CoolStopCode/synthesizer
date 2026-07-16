class_name Sampler_Voice
extends RefCounted

@export var audio_stream : AudioStreamWAV
@export var base_frequency : float
@export var release : float

#static func from_audio(audio : AudioStreamWAV) -> Sampler_Sample
	#pass
