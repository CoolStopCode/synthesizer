class_name EnvelopeModule
extends Module

enum State {
	IDLE,
	ATTACK,
	DECAY,
	SUSTAIN,
	RELEASE
}

@export_category("SETTINGS")
@export var attack: float = 0.1
@export var decay: float = 0.1
@export var sustain: float = 0.5
@export var release: float = 0.1

@export var velocity: float = 1.0

@export_category("PORTS")
@export var active_in: BoolPort
@export var output_out: FloatPort

# PRIVATE
var output: float = 0.0
var state: State = State.IDLE

func _init():
	inputs = [
		active_in
	]
	outputs = [
		output_out
	]

func process(delta : float) -> void:
	var active : bool = active_in.value
	
	if not active and state == State.IDLE:
		output_out.value = 0.0
		return
	
	if active:
		if state == State.IDLE or state == State.RELEASE:
			state = State.ATTACK
	elif state != State.IDLE and state != State.RELEASE:
		state = State.RELEASE
	
	match state:
		State.IDLE:
			output_out.value = 0.0
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
			output = sustain

		State.RELEASE:
			output -= delta / max(release, 0.0001)
			if output <= 0.0:
				output = 0.0
				state = State.IDLE
	
	output_out.value = output
	return
