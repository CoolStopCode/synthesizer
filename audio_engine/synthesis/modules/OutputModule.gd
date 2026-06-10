class_name OutputModule
extends Module

@export_category("SETTINGS")
@export var audio : float

@export_category("PORTS")
@export var audio_in : FloatPort

func _init() -> void:
	inputs = [
		audio_in
	]
	outputs = []

func process(delta : float):
	audio = audio_in.value
