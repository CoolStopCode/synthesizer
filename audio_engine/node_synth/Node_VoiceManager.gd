class_name Node_VoiceManager

enum Allocation {
	POLY,
	MONO,
	LEGATO
}

static var polyvoices: Array[Node_Polyvoice] = []

static var allocation: Allocation
static var active_legato : Node_Polyvoice

static func polyvoice_on(index: int) -> void:
	if allocation == Allocation.MONO or allocation == Allocation.LEGATO:
		for polyvoice in polyvoices:
			polyvoice.voice_off()
	active_legato = polyvoices[index]
	polyvoices[index].voice_on()

static func polyvoice_off(index: int) -> void:
	polyvoices[index].voice_off()

static func process_mix(delta: float) -> float:
	var sum: float = 0.0
	for polyvoice in polyvoices:
		var sample := polyvoice.process(delta)
		if allocation == Allocation.LEGATO:
			if active_legato != polyvoice:
				continue
		sum += sample
	return sum

static func modify_polyvoice_chord(polyvoice : Node_Polyvoice, chord : Chord) -> void:
	var i : int = 0
	for voice in polyvoice.voices:
		voice.frequency = chord.semitones[i].to_frequency()
		i += 1
