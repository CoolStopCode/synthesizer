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
			polyvoice.polyvoice_off()
		polyvoices[index].polyvoice_on()
	
	elif allocation == Allocation.LEGATO:
		#if active_legato == polyvoices[index]:
			#polyvoices[index].voice_on()
		#else:
		active_legato = polyvoices[index]
		for polyvoice in polyvoices:
			if polyvoice == polyvoices[index]:
				polyvoice.fade_amplitude_to(1.0, fade_duration)
				polyvoice.polyvoice_on()
			else:
				polyvoice.fade_amplitude_to(0.0, fade_duration)
				polyvoice.polyvoice_off()
			
	
	elif allocation == Allocation.POLY:
		polyvoices[index].polyvoice_on()


static func polyvoice_off(index: int) -> void:
	polyvoices[index].polyvoice_off()

static func bend_polyvoice(polyvoice: Node_Polyvoice, chord: Chord, chord_bend_duration : float) -> void:
	polyvoice.bend_polyvoice(chord, chord_bend_duration)

static func process_mix(delta: float) -> float:
	var sum: float = 0.0
	
	for polyvoice in polyvoices:
		var sample := polyvoice.process(delta)
		sum += sample
	
	return sum
