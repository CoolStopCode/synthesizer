class_name SamplerAudioMode
extends TonalAudioMode

@export var sample : SamplerAudioSample
@export var sample_amplitude = 1.0
@export var attack : float
@export var release : float

var active_legato : SamplerAudioPolyvoice
var polyvoices : Array[SamplerAudioPolyvoice]

func process(delta : float) -> float:
	var sum: float = 0.0
	
	for polyvoice in polyvoices:
		sum += polyvoice.process(delta)
	
	return sum * sample_amplitude

func build() -> void:
	super.build()
	var decoded_stream := sample.decode_stream(sample.audio_stream.data)
	var base_frequency := sample.estimate_root_frequency(48000,49000)
	
	for i in range(polyvoice_count):
		var polyvoice := SamplerAudioPolyvoice.new()
		polyvoice.attack = attack
		polyvoice.release = release
		for j in range(voice_count):
			var voice := SamplerAudioVoice.new()
			voice.base_frequency = base_frequency
			voice.sample_rate = sample.audio_stream.mix_rate
			voice.audio_stream = decoded_stream
			polyvoice.voices.append(voice)
		polyvoices.append(polyvoice)

func key_pressed(index: int) -> void:
	var pressed_polyvoice := polyvoices[index]
	pressed_polyvoice.bend_polyvoice(build_chord(index), 0.0)
	active_legato = pressed_polyvoice
	
	if allocation == Allocation.MONO:
		for polyvoice in polyvoices:
			polyvoice.polyvoice_off()
		pressed_polyvoice.polyvoice_on()
		
		return
	
	if allocation == Allocation.LEGATO:
		for polyvoice in polyvoices:
			if polyvoice == pressed_polyvoice:
				polyvoice.fade_transition_to(1.0, fade_duration)
				polyvoice.polyvoice_on()
			else:
				polyvoice.fade_transition_to(0.0, fade_duration)
				polyvoice.polyvoice_off()
		
		return
	
	if allocation == Allocation.POLY:
		pressed_polyvoice.polyvoice_on()
		
		return

func key_released(index: int) -> void:
	var released_polyvoice := polyvoices[index]
	released_polyvoice.polyvoice_off()

func bend_changed() -> void:
	var i := 0
	for polyvoice in polyvoices:
		if polyvoice.active:
			polyvoice.bend_polyvoice(build_chord(i), chord_bend_duration)
		i += 1
