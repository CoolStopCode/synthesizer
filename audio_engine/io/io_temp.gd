extends Node

func _process(_delta: float) -> void:
	handle_input()

func handle_input() -> void:
	for i in range(7):
		var action := "Key%d" % (i + 1)
		if Input.is_action_just_pressed(action):
			AudioEngine.key_pressed(i)
		if Input.is_action_just_released(action):
			AudioEngine.key_released(i)
	
	var direction := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	var any_just_changed := (
		Input.is_action_just_pressed("ui_right") or Input.is_action_just_released("ui_right") or
		Input.is_action_just_pressed("ui_left") or Input.is_action_just_released("ui_left") or
		Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_down") or
		Input.is_action_just_pressed("ui_up") or Input.is_action_just_released("ui_up")
	)
	
	if any_just_changed:
		AudioEngine.joystick_moved(direction)
