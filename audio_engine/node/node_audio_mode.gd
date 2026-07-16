class_name NodeAudioMode
extends TonalAudioMode

@export var layout : Node_Layout

var polyvoices: Array[Node_Polyvoice] = []
var active_legato: Node_Polyvoice

func process(delta : float) -> float:
	var sum: float = 0.0
	
	for polyvoice in polyvoices:
		sum += polyvoice.process(delta)
	
	return sum

func build() -> void:
	super.build()
	polyvoices = layout.to_polyvoices(polyvoice_count, voice_count)

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
				polyvoice.fade_amplitude_to(1.0, fade_duration)
				polyvoice.polyvoice_on()
			else:
				polyvoice.fade_amplitude_to(0.0, fade_duration)
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
