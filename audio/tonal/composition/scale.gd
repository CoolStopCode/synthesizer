class_name TonalScale
extends RefCounted

var root : TonalSemitone
var intervals : Array[int]

func get_semitone(index: int) -> TonalSemitone:
	var semitone := TonalSemitone.new()
	var octave_offset: int = floor((index / 7) * 12)
	semitone.semitone = root.semitone + intervals[index % 7] + octave_offset
	return semitone

func get_chord(root_index: int, degrees: Array[int]) -> TonalChord:
	var chord := TonalChord.new()
	for degree in degrees:
		chord.semitones.append(get_semitone(root_index + degree))
	return chord
