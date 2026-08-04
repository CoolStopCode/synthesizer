class_name Scale
extends RefCounted

var root : Semitone
var intervals : Array[int]

func get_semitone(index: int) -> Semitone:
	var semitone := Semitone.new()
	var octave_offset: int = floor((index / 7) * 12)
	semitone.semitone = root.semitone + intervals[index % 7] + octave_offset
	return semitone

func get_chord(root_index: int, degrees: Array[int]) -> Chord:
	var chord := Chord.new()
	for degree in degrees:
		chord.semitones.append(get_semitone(root_index + degree))
	return chord

#func root_note(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index)
	#])
#
#func triad(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 2),
		#get_semitone(root_index + 4)
	#])
#
#func triad_parallel(root_index: int) -> Chord:
	#var third := get_semitone(root_index + 2).semitone
	#var root_semi := get_semitone(root_index).semitone
	#var interval := third - root_semi
	#if interval == 4:
		#third -= 1  # major -> minor
	#else:
		#third += 1  # minor -> major
	#return Chord.new([
		#Semitone.new(root_semi),
		#Semitone.new(third),
		#get_semitone(root_index + 4)
	#])
#
#func open_fifth(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 4)
	#])
#
#func sixth(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 2),
		#get_semitone(root_index + 4),
		#get_semitone(root_index + 5)
	#])
#
#func sixth_omit_fifth(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 2),
		#get_semitone(root_index + 5)
	#])
#
#func cinimatic(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 3),
		#get_semitone(root_index + 5)
	#])
#
#func seventh(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 2),
		#get_semitone(root_index + 4),
		#get_semitone(root_index + 6)
	#])
#
#func ninth(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 2),
		#get_semitone(root_index + 4),
		#get_semitone(root_index + 6),
		#get_semitone(root_index + 8)
	#])
#
#func sus2(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 1),
		#get_semitone(root_index + 4)
	#])
#
#func sus4(root_index: int) -> Chord:
	#return Chord.new([
		#get_semitone(root_index),
		#get_semitone(root_index + 3),
		#get_semitone(root_index + 4)
	#])
