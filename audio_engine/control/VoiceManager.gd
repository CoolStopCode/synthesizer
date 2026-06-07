class_name VoiceManager
extends Node

@export var polyvoices: int = 7

var polyvoice_pool: Array[Polyvoice] = []

func set_polyvoice_pool(_polyvoice_pool : Array[Polyvoice]):
	polyvoice_pool = _polyvoice_pool

func polyvoice_on(index : int):
	polyvoice_pool[index].voice_on()

func polyvoice_off(index : int):
	polyvoice_pool[index].voice_off()

func process_mix(delta : float) -> float:
	var sum : float = 0.0
	
	for polyvoice in polyvoice_pool:
		sum += polyvoice.process(delta)
	
	return sum
