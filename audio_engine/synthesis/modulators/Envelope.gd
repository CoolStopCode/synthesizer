class_name Envelope
extends Modulator

enum State {
	IDLE,
	ATTACK,
	DECAY,
	SUSTAIN,
	RELEASE
}

var state: State = State.IDLE

var attack: float = 0.05
var decay: float = 0.1
var sustain: float = 0.7
var release: float = 0.2

var velocity: float = 1.0
var output: float = 0.0

func voice_on() -> void:
	state = State.ATTACK

func voice_off() -> void:
	state = State.RELEASE

func process(delta: float) -> void:
	match state:
		State.IDLE:
			parameter.value = 0.0
			return

		State.ATTACK:
			output += delta / max(attack, 0.0001)
			if output >= velocity:
				output = velocity
				state = State.DECAY

		State.DECAY:
			output -= delta * ((velocity - sustain) / max(decay, 0.0001))
			if output <= sustain:
				output = sustain
				state = State.SUSTAIN

		State.SUSTAIN:
			pass

		State.RELEASE:
			output -= delta / max(release, 0.0001)
			if output <= 0.0:
				output = 0.0
				state = State.IDLE

	parameter.value = output
	return
