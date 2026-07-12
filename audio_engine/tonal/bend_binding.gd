class_name BendBinding
extends Resource

@export var bend_binding : Dictionary[Vector3i, BendBehavior]

func build_chord(scale : Scale, index : int, bend : Vector3i):
	return bend_binding[bend].build_chord(scale, index)
