class_name Tonal_BendBinding
extends Resource

@export var bend_binding : Dictionary[Vector3i, Tonal_BendBehavior]

func build_chord(scale : Scale, index : int, bend : Vector3i):
	return bend_binding[bend].build_chord(scale, index)
