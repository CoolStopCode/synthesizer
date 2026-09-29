class_name TonalAudioDropChordTransformation
extends TonalAudioChordTransformation

@export var semitone_from_top : int = 2

func apply(chord : TonalAudioChord) -> void:
	if semitone_from_top > chord.semitones.size() or semitone_from_top <= 0: return
	
	var index : int = chord.semitones.size() - semitone_from_top
	
	var semitone : TonalAudioSemitone = chord.semitones[index]
	semitone.shift_octave(-1)
