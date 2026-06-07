class_name InputModule
extends Module

# SETTINGS
var active : bool
var frequency : float

# PORTS
var active_out : BoolPortOut
var frequency_out : FloatPortOut

func _init() -> void:
	active_out = BoolPortOut.new()
	frequency_out = FloatPortOut.new()
	
	inputs = []
	outputs = [
		active_out,
		frequency_out
	]

func process(delta : float):
	active_out.set_value(active)
	frequency_out.set_value(frequency)
