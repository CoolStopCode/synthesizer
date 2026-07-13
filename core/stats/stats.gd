extends Control

@export var fps_label: Label
@export var memory_label: Label
@export var objects_label: Label

func _process(_delta: float) -> void:
	if not visible:
		return
	update_fps()
	update_memory()
	update_objects()

func update_fps() -> void:
	var fps := Engine.get_frames_per_second()
	var frame_ms : float = 1000.0 / max(Engine.get_frames_per_second(), 1)
	frame_ms = snappedf(frame_ms, 0.1)

	if fps < 30:
		fps_label.modulate = Color.RED
	elif fps < 55:
		fps_label.modulate = Color.YELLOW
	else:
		fps_label.modulate = Color.WHITE
	
	fps_label.text = "FPS: " + str(fps) + " | " + str(frame_ms) + "ms"

func update_memory() -> void:
	var static_mem := OS.get_static_memory_usage() / 1024.0 / 1024.0
	memory_label.text = "Mem: %.1f MB" % static_mem

func update_objects() -> void:
	var objects := Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)
	objects_label.text = "Objects: %d" % objects
