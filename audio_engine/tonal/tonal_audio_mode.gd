## An abstract class that provides an AudioMode class with music theory and chord building structures
@abstract class_name TonalAudioMode
extends AudioMode

enum Allocation {
	POLY, # Any polyvoices can be active and unmuted
	MONO, # Only one polyvoice can be active, but any can be unmuted
	LEGATO, # Only one polyvoice can be active and unmuted
}

@export var polyvoice_count: int = 7
@export var voice_count: int = 5 ## Voices per polyvoice
@export var allocation: Allocation
@export var fade_duration : float = 0.05 ## Used for legato allocation, prevents clipping
@export var chord_bend_duration : float = 0.1 ## Linear fade time for bending an active polyvoice
@export var key : Key
@export var bend_binding : Tonal_BendBinding

var scale : Scale

func build_chord(index: int) -> Chord:
	return bend_binding.build_chord(scale, index, bend)

func build() -> void:
	scale = key.build_scale()
	
	var chords : Array[Chord]
	for i in range(polyvoice_count):
		var chord : Chord = Chord.new()
		#print(scale.root_note(i).get_semitone(0).to_string_name())
		chords.append(chord)
