class_name FloatPortIn
extends PortIn

var source : FloatPortOut = null

func get_value() -> float:
	return source.value
