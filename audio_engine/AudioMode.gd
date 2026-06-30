class_name AudioMode
extends Resource

func process(delta : float) -> float:
	return 0.0

func build(chords : Array[Chord]) -> void:
	pass

func key_pressed(index: int) -> void:
	pass

func key_released(index: int) -> void:
	pass

func joystick_moved(direction : Vector2) -> void:
	pass
