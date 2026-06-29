class_name Scale
extends Resource

@export var root : Semitone
@export var intervals : Array[int]

func get_semitone(index: int) -> int:
	var octave_offset: int = floor((index / 7) * 12)
	return root.semitone + intervals[index % 7] + octave_offset

func triad(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index)),
		Semitone.new(get_semitone(root_index + 2)),
		Semitone.new(get_semitone(root_index + 4))
	])
