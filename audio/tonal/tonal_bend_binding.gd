class_name TonalAudioBendBinding
extends Resource

@export var bend_binding : Dictionary[Vector3i, TonalAudioBendBehavior]

func build_chord(scale : TonalAudioScale, index : int, bend : Vector3i):
	return bend_binding[bend].build_chord(scale, index)
