extends Control

@onready var main: Control = $SubViewportContainer/SubViewport/main
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport


func _process(delta):
	var screen_size = DisplayServer.screen_get_size()

	var scale_factor = floor(screen_size.y / 72.0)

	sub_viewport.size = screen_size / scale_factor
	sub_viewport_container.scale = Vector2.ONE * scale_factor
