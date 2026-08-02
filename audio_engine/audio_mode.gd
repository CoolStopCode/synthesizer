@abstract
class_name AudioMode
extends Resource

var bend : Vector3i

@abstract func process(delta : float) -> float

@abstract func build() -> void

@abstract func key_pressed(index: int) -> void
@abstract func key_released(index: int) -> void

@abstract func bend_changed() -> void
