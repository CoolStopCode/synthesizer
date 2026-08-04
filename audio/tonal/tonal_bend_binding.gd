class_name TonalBendBinding
extends Resource

@export var bend_binding : Dictionary[Vector3i, TonalBendBehavior]

func build_chord(scale : Scale, index : int, bend : Vector3i):
	return bend_binding[bend].build_chord(scale, index)
