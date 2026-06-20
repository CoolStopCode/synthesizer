class_name Node_VoiceManager

static var polyvoices: Array[Node_Polyvoice] = []

static func set_polyvoices(_polyvoices: Array[Node_Polyvoice]) -> void:
	polyvoices = _polyvoices

static func polyvoice_on(index: int) -> void:
	polyvoices[index].voice_on()

static func polyvoice_off(index: int) -> void:
	polyvoices[index].voice_off()

static func polyvoices_off() -> void:
	for polyvoice in polyvoices:
		polyvoice.voice_off()
	
static func process_mix(delta: float) -> float:
	var sum: float = 0.0
	for polyvoice in polyvoices:
		sum += polyvoice.process(delta)
	return sum
