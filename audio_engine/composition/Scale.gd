class_name Scale
extends Resource

@export var root : Semitone
@export var intervals : Array[int]

func get_semitone(index: int) -> int:
	var octave_offset: int = floor((index / 7) * 12)
	return root.semitone + intervals[index % 7] + octave_offset

func root_note(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index))
	])

func power(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index)),
		Semitone.new(get_semitone(root_index + 4))
	])

func boosted(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index)),
		Semitone.new(get_semitone(root_index + 3)),
		Semitone.new(get_semitone(root_index + 5))
	])

func triad(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index)),
		Semitone.new(get_semitone(root_index + 2)),
		Semitone.new(get_semitone(root_index + 4))
	])

func triad_flip_third(root_index: int) -> Chord:
	var third := get_semitone(root_index + 2)
	var root_semi := get_semitone(root_index)
	var interval := third - root_semi
	if interval == 4:
		third -= 1  # major -> minor
	else:
		third += 1  # minor -> major
	return Chord.new([
		Semitone.new(root_semi),
		Semitone.new(third),
		Semitone.new(get_semitone(root_index + 4))
	])

func seventh(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index)),
		Semitone.new(get_semitone(root_index + 2)),
		Semitone.new(get_semitone(root_index + 4)),
		Semitone.new(get_semitone(root_index + 6))
	])

func ninth(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index)),
		Semitone.new(get_semitone(root_index + 2)),
		Semitone.new(get_semitone(root_index + 4)),
		Semitone.new(get_semitone(root_index + 6)),
		Semitone.new(get_semitone(root_index + 8))
	])

func sus2(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index)),
		Semitone.new(get_semitone(root_index + 1)),
		Semitone.new(get_semitone(root_index + 4))
	])

func sus4(root_index: int) -> Chord:
	return Chord.new([
		Semitone.new(get_semitone(root_index)),
		Semitone.new(get_semitone(root_index + 3)),
		Semitone.new(get_semitone(root_index + 4))
	])
