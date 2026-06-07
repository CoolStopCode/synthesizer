class_name OutputModule
extends Module

# SETTINGS
var audio : float

# PORTS
var audio_in : FloatPortIn

func _init() -> void:
	audio_in = FloatPortIn.new()
	
	inputs = [
		audio_in
	]
	outputs = []

func process(delta : float):
	audio = audio_in.get_value()
