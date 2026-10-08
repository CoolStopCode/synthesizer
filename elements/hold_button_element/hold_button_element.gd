class_name HoldButtonElement
extends ButtonElement

signal triggered

@export var hold_time : float

@export_group("private")
@export var progress_node: NinePatchRect

var triggering : bool = false
var tween : Tween

func _ready() -> void:
	super()
	button_down.connect(start_triggering)
	button_up.connect(end_triggering)
	progress_node.material.set_shader_parameter("size", progress_node.size * 1000)

func start_triggering():
	triggering = true
	Haptics.start_vibration()
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_method(
		set_progress,
		0.0,
		1.0,
		hold_time
	).set_trans(Tween.TRANS_LINEAR)

	tween.tween_callback(on_hold_finished)

func set_progress(value: float) -> void:
	progress_node.material.set_shader_parameter("progress", value)

func end_triggering():
	if not triggering:
		return
	
	triggering = false
	Haptics.stop_vibration()
	
	if tween:
		tween.kill()
		tween = null
	
	set_progress(0.0)

func on_hold_finished() -> void:
	if not triggering:
		return
	
	triggering = false
	Haptics.stop_vibration()
	
	if tween:
		tween.kill()
		tween = null
	
	set_progress(0.0)
	
	is_pressed = false
	button_up.emit()
	triggered.emit()
	
	tooltip_timer.stop()
	tooltip_node.hide()
	if is_hovered:
		pressed.emit()
	update_visuals()

func update_visuals() -> void:
	super()
	progress_node.self_modulate = color.get_progress_color(is_pressed)
	progress_node.texture = shape.outline_texture
	progress_node.patch_margin_top    = shape.margin
	progress_node.patch_margin_bottom = shape.margin
	progress_node.patch_margin_left   = shape.margin
	progress_node.patch_margin_right  = shape.margin
