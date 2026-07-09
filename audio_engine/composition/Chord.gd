class_name Chord
extends RefCounted

var semitones : Array[Semitone]

func _init(_semitones : Array[Semitone] = []) -> void:
	semitones = _semitones

func append_semitone(semitone : Semitone) -> Chord:
	semitones.append(semitone)
	return self

func remove_semitone(semitone : Semitone) -> Chord:
	semitones.erase(semitone)
	return self

func shift_octave(octave: int) -> Chord:
	for semitone in semitones:
		semitone.shift_octave(octave)
	return self

func transpose(amount : int) -> Chord:
	for semitone in semitones:
		semitone.transpose(amount)
	return self

func transpose_to_root(new_root : Semitone) -> Chord:
	if semitones.is_empty():
		return self
	var current_root := root()
	return transpose(new_root.semitone - current_root.semitone)

func octave_double(octave : int) -> Chord:
	for semitone in semitones.duplicate():
		append_semitone(
			Semitone.new(semitone.semitone).shift_octave(octave)
		)
	return self

func sort_ascending() -> Chord:
	semitones.sort_custom(
		func(a, b): return a.semitone < b.semitone
	)
	return self

func sort_descending() -> Chord:
	semitones.sort_custom(
		func(a, b): return a.semitone > b.semitone
	)
	return self

func root() -> Semitone:
	var lowest := semitones[0]
	for semitone in semitones:
		if semitone.semitone < lowest.semitone:
			lowest = semitone
	return lowest

func top() -> Semitone:
	var highest := semitones[0]
	for semitone in semitones:
		if semitone.semitone > highest.semitone:
			highest = semitone
	return highest

func get_semitone(index : int) -> Semitone:
	return semitones[index]

func remove_duplicates() -> Chord:
	var seen : Array[Semitone] = []
	var unique : Array[Semitone] = []
	for semitone in semitones:
		var has_seen := false
		for seen_semitone in seen:
			if semitone.semitone == seen_semitone.semitone:
				has_seen = true
				break
		if not has_seen:
			seen.append(semitone)
			unique.append(semitone)
	semitones = unique
	return self

func shift_semitone_octave(semitone : Semitone, octave : int = -1) -> Chord:
	var index := semitones.find(semitone)
	if index == -1: return self
	semitones[index].shift_octave(octave)
	return self

func invert(amount : int, octave : int = 1) -> Chord:
	sort_ascending()
	
	for i in range(min(amount, semitones.size())):
		semitones[i].shift_octave(octave)
	
	sort_ascending()
	return self
