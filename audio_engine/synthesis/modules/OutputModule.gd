class_name GDOutputModule
extends GDModule

@export_category("SETTINGS")
@export var audio : float

@export_category("PORTS")
@export var IN_audio : GDFloatPort

func _init() -> void:
	inputs = [
		IN_audio
	]
	outputs = []

func process(delta : float):
	audio = IN_audio.value
