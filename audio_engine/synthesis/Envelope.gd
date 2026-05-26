class_name Envelope

enum State {
	IDLE,
	ATTACK,
	DECAY,
	SUSTAIN,
	RELEASE
}

var state := State.IDLE

var attack  : float = 0.05  # Seconds
var decay   : float = 0.1   # Seconds
var sustain : float = 0.7   # Volume
var release : float = 0.2   # Seconds

var velocity: float = 1.0

var volume := 0.0

func _init(
	_attack : float = 0.01, 
	_decay : float = 0.01, 
	_sustain : float = 0.7, 
	_release : float = 0.2, 
	_velocity : float = 1.0
) -> void:
	attack   = _attack
	decay    = _decay
	sustain  = _sustain
	release  = _release
	velocity = _velocity


func process(delta: float, is_pressed: bool) -> float:
	match state:
		State.IDLE:
			if is_pressed:
				state = State.ATTACK

		State.ATTACK:
			volume += delta / attack
			if volume >= velocity:
				volume = velocity
				state = State.DECAY

		State.DECAY:
			volume -= delta * ((velocity - sustain) / decay)
			if volume <= sustain:
				volume = sustain
				state = State.SUSTAIN

		State.SUSTAIN:
			if !is_pressed:
				state = State.RELEASE

		State.RELEASE:
			volume -= delta / release
			if volume <= 0.0:
				volume = 0.0
				state = State.IDLE

	return volume
