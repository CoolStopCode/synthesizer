class_name BoolPortIn
extends PortIn

var source : BoolPortOut = null

func get_value() -> bool:
	return source.value
