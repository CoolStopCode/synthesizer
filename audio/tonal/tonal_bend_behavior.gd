class_name TonalAudioBendBehavior
extends Resource

@export var degrees : Array[int]
@export var transformations : Array[TonalAudioChordTransformation]

func build_chord(scale : TonalAudioScale, index : int) -> TonalAudioChord:
	var chord := scale.get_chord(index, degrees)
	
	for transformation in transformations:
		transformation.apply(chord)
	
	return chord
