class_name Node_VoiceManager

enum Allocation {
	POLY,
	MONO,
	LEGATO,
}

static var polyvoices: Array[Node_Polyvoice] = []
static var allocation: Allocation
static var active_legato: Node_Polyvoice


static func polyvoice_on(index: int, fade_duration : float) -> void:
	if allocation == Allocation.MONO:
		for polyvoice in polyvoices:
			polyvoice.polyvoice_off(false)
		polyvoices[index].polyvoice_on(false)
	
	elif allocation == Allocation.LEGATO:
		#if active_legato == polyvoices[index]:
			#polyvoices[index].voice_on()
		#else:
		active_legato = polyvoices[index]
		for polyvoice in polyvoices:
			if polyvoice == polyvoices[index]:
				polyvoice.polyvoice_on(true, fade_duration)
			else:
				polyvoice.polyvoice_off(true, fade_duration)
			
	
	elif allocation == Allocation.POLY:
		polyvoices[index].polyvoice_on(false)


static func polyvoice_off(index: int) -> void:
	polyvoices[index].polyvoice_off(false)


static func process_mix(delta: float) -> float:
	var sum: float = 0.0
	
	for polyvoice in polyvoices:
		var sample := polyvoice.process(delta)
		sum += sample
	
	return sum


static func bend_polyvoice(polyvoice: Node_Polyvoice, chord: Chord, chord_bend_duration : float) -> void:
	for i in polyvoice.voices.size():
		var voice : Node_Voice = polyvoice.voices[i]
		var has_note := i < chord.semitones.size()
		
		if not has_note:
			voice.bend_amplitude_to(0.0, chord_bend_duration)
		if has_note:
			var frequency = chord.semitones[i].to_frequency()
			voice.bend_amplitude_to(1.0, chord_bend_duration)
			voice.bend_frequency_to(frequency, chord_bend_duration)
