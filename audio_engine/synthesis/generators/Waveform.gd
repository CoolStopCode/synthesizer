class_name Waveform
extends Resource

enum Type {
	SINE,
	SQUARE,
	SAW,
	TRIANGLE,
	CUSTOM
}

@export var type: Type = Type.SINE
@export var curve: Curve

func _init(_type : Type = Type.SINE) -> void:
	type = _type

func evaluate(phase : float) -> float:
	phase = fmod(phase, 1.0)
	var amplitude : float
	match type:
		Type.SINE:
			amplitude = sin(phase * TAU)
		Type.SQUARE:
			amplitude = 1.0 if phase < 0.5 else -1.0
		Type.SAW:
			amplitude = (phase * 2.0) - 1.0
		Type.TRIANGLE:
			amplitude =  1.0 - 4.0 * abs(phase - 0.5)
		Type.CUSTOM:
			amplitude = 1.0
		_:
			amplitude = 0.0
	return amplitude * curve.sample(phase) if curve else amplitude
