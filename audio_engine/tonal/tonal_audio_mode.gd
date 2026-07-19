@abstract
class_name TonalAudioMode
extends AudioMode

enum Allocation {
	POLY,
	MONO,
	LEGATO,
}

@export var polyvoice_count: int = 7
@export var voice_count: int = 5
@export var allocation: Allocation
@export var fade_duration : float = 0.05
@export var chord_bend_duration : float = 0.1
@export var key : Key
@export var bend_binding : BendBinding

var scale : Scale

func build_chord(index: int) -> Chord:
	return bend_binding.build_chord(scale, index, bend)

func build() -> void:
	scale = key.build_scale()
	
	var chords : Array[Chord]
	for i in range(7):
		var chord : Chord = Chord.new()
		#print(scale.root_note(i).get_semitone(0).to_string_name())
		chords.append(chord)
	
	
