class_name Envelope
extends Resource

enum State {
	IDLE,
	ATTACK,
	DECAY,
	SUSTAIN,
	RELEASE
}

var state := State.IDLE

@export var attack  : float = 0.05  # Seconds
@export var decay   : float = 0.1   # Seconds
@export var sustain : float = 0.7   # Volume
@export var release : float = 0.2   # Seconds

@export var velocity: float = 1.0

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
