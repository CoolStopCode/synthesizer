class_name OutputModule
extends Module

@export_category("SETTINGS")
@export var audio : float

@export_category("PORTS")
@export var IN_audio : FloatPort

func _init() -> void:
	inputs = [
		IN_audio
	]
	outputs = []

func process(delta : float):
	audio = IN_audio.value
