class_name BendBehavior
extends Resource

enum Base {
	ROOT_NOTE,
	TRIAD,
	TRIAD_PARALLEL,
	OPEN_FIFTH,
	SIXTH,
	SIXTH_OMIT_FIFTH,
	CINIMATIC,
	SEVENTH,
	NINTH,
	SUS2,
	SUS4
}

func get_base(scale : Scale, index: int) -> Chord:
	match base:
		Base.ROOT_NOTE:         return scale.root_note(index)
		Base.TRIAD:             return scale.triad(index)
		Base.TRIAD_PARALLEL:    return scale.triad_parallel(index)
		Base.OPEN_FIFTH:        return scale.open_fifth(index)
		Base.SIXTH:             return scale.sixth(index)
		Base.SIXTH_OMIT_FIFTH:  return scale.sixth_omit_fifth(index)
		Base.CINIMATIC:         return scale.cinimatic(index)
		Base.SEVENTH:           return scale.seventh(index)
		Base.NINTH:             return scale.ninth(index)
		Base.SUS2:              return scale.sus2(index)
		Base.SUS4:              return scale.sus4(index)

	return Chord.new()

enum Transformation {
	SHIFT_OCTAVE_UP_1,
	SHIFT_OCTAVE_DOWN_1,
	TRANSPOSE_UP_1,
	TRANSPOSE_DOWN_1,
	DOUBLE_OCTAVE_DOWN_1,
	DOUBLE_OCTAVE_UP_1,
	INVERT1,
	INVERT2
}

func apply_transformation(chord : Chord, transformation : Transformation) -> Chord:
	match transformation:
		Transformation.SHIFT_OCTAVE_UP_1:       return chord.shift_octave(1)
		Transformation.SHIFT_OCTAVE_DOWN_1:     return chord.shift_octave(-1)
		Transformation.TRANSPOSE_UP_1:          return chord.transpose(1)
		Transformation.TRANSPOSE_DOWN_1:        return chord.transpose(-1)
		Transformation.DOUBLE_OCTAVE_DOWN_1:    return chord.octave_double(-1)
		Transformation.DOUBLE_OCTAVE_UP_1:      return chord.octave_double(1)
		Transformation.INVERT1:                 return chord.invert(1, 1)
		Transformation.INVERT2:                 return chord.invert(2, 1)

	return Chord.new()

func apply_transformations(chord : Chord) -> Chord:
	for transformation in transformations:
		chord = apply_transformation(chord, transformation)
	return chord

func build_chord(scale : Scale, index : int) -> Chord:
	var chord : Chord
	chord = get_base(scale, index)
	chord = apply_transformations(chord)
	return chord

@export var base : Base
@export var transformations : Array[Transformation]

func _init(_base : Base = Base.ROOT_NOTE, _transformations : Array[Transformation] = []) -> void:
	base = _base
	transformations = _transformations
