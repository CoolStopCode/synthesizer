class_name TonalBendBehavior
extends Resource

@export var degrees : Array[int]
@export var transformations : Array[TonalChordTransformation]

func build_chord(scale : TonalScale, index : int) -> TonalChord:
	var chord := scale.get_chord(index, degrees)
	
	for transformation in transformations:
		transformation.apply(chord)
	
	return chord
