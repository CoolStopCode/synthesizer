class_name FloatPortIn
extends PortIn

@export var source : FloatPortOut = null

func get_value() -> float:
	return source.value
