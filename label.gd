extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Key1"):
		show()
	if Input.is_action_just_released("Key1"):
		hide()
