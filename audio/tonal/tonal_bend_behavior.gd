class_name TonalBendBehavior
extends Resource

@export var degrees : Array[int]
@export var transformations : Array[ChordTransformation]

func build_chord(scale : Scale, index : int) -> Chord:
	var chord := scale.get_chord(index, degrees)
	
	for transformation in transformations:
		transformation.apply(chord)
	
	return chord
