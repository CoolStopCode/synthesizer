class_name ModularAudioMode
extends TonalAudioMode

@export var layout : ModularLayout

var polyvoices: Array[ModularPolyvoice] = []

## Simply processes each polyvoice and returns the sum of their outpus
func process(delta : float) -> float:
	var sum: float = 0.0
	
	for polyvoice in polyvoices:
		sum += polyvoice.process(delta)
	
	return sum

func build() -> void:
	super.build() # This overrides TonalAudioMode's build function, so we must call it again
	polyvoices = layout.to_polyvoices(polyvoice_count, voice_count)

func key_pressed(index: int) -> void:
	var pressed_polyvoice := polyvoices[index]
	pressed_polyvoice.bend_polyvoice(build_chord(index), 0.0) # Snap the polyvoice to the correct chord instanly
	
	match allocation:
		Allocation.POLY: # Activate the pressed polyvoice
			pressed_polyvoice.polyvoice_on()
		
		Allocation.MONO: # Deactivate other polyvoices and activate the pressed polovoice
			for polyvoice in polyvoices:
				polyvoice.polyvoice_off()
			pressed_polyvoice.polyvoice_on()
		
		Allocation.LEGATO: # Mute and deactivate other polyvoices, unmute and activate pressed polyvoice
			for polyvoice in polyvoices:
				if polyvoice == pressed_polyvoice:
					polyvoice.fade_amplitude_to(1.0, fade_duration)
					polyvoice.polyvoice_on()
				else:
					polyvoice.fade_amplitude_to(0.0, fade_duration)
					polyvoice.polyvoice_off()

func key_released(index: int) -> void:
	var released_polyvoice := polyvoices[index]
	released_polyvoice.polyvoice_off()

## Bend all currently active polyvoices to their new chords
func bend_changed() -> void:
	for i in polyvoices.size():
		var polyvoice = polyvoices[i]
		if polyvoice.active:
			polyvoice.bend_polyvoice(build_chord(i), chord_bend_duration)
