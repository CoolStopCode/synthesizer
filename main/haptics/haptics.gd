extends Node

@export var interval: float = 0.1
@export var padding: float = 0.05

var is_vibrating: bool = false
var timer: float = 0.0

func _process(delta: float) -> void:
	if is_vibrating:
		timer += delta
		if timer >= interval or timer == delta:
			Input.vibrate_handheld(interval * 1000.0 + padding * 1000.0)
			timer = 0.0

func start_vibration() -> void:
	is_vibrating = true
	timer = 0.0

func stop_vibration() -> void:
	is_vibrating = false
