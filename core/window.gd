extends Control

@export var main : Control
@export var sub_viewport_container: SubViewportContainer
@export var sub_viewport: SubViewport

func _ready() -> void:
	get_window().size_changed.connect(_on_window_size_changed)
	_on_window_size_changed()

func _on_window_size_changed() -> void:
	var screen_size = DisplayServer.screen_get_size()

	var scale_factor = floor(screen_size.y / 72.0)

	sub_viewport.size = screen_size / scale_factor
	sub_viewport_container.scale = Vector2.ONE * scale_factor
	print(sub_viewport.size)
