@abstract
class_name AudioMode
extends Resource

var joystick_direction : Vector2

@abstract func process(delta : float) -> float

@abstract func build(scale : Scale) -> void

@abstract func key_pressed(index: int) -> void

@abstract func key_released(index: int) -> void

@abstract func joystick_moved() -> void
