class_name NewVoice
extends Resource

# ========================= FORMAT =========================
# Each array in the modules array represents a module
# [ModuleType, [settings], [private], [ports in], [ports out]
# ports in: [[module index, port index], [module index, port index]]
# ports out [value, value, value]
# ==========================================================

enum ModuleType {
	INPUT,
	OUTPUT,
	OSCILLATOR,
	ENVELOPE,
	ARITHMATIC
}

@export var output_module : int
@export var modules : Array[Array] = [
	[
		ModuleType.INPUT,
		[],
		[0.0, 0.0],
		[],
		[0.0, 0.0]
	],
	[
		ModuleType.OSCILLATOR,
		[0.0],
		[0.0],
		[[0, 1]],
		[0.0]
	],
	[
		ModuleType.ENVELOPE,
		[0.1, 0.3, 0.4, 1.5, 0.5],
		[0.0, 0.0],
		[[0, 0]],
		[0.0]
	],
	[
		ModuleType.ARITHMATIC,
		[2.0],
		[],
		[[1, 0], [2, 0]],
		[0.0]
	],
	[
		ModuleType.OUTPUT,
		[],
		[0.0],
		[[3, 0]],
		[]
	]
]

@export var input_active : bool
@export var input_frequency : float

func voice_on():
	input_active = true

func voice_off():
	input_active = false

func process(delta : float, ) -> float:
	for i in range(modules.size()):
		var module : Array = modules[i]
		
		var type : ModuleType = module[0]
		var settings : Array = module[1]
		var private : Array = module[2]
		var ports_in : Array = module[3]
		var ports_out : Array = module[4]
		
		match type:
			ModuleType.INPUT:
				# SETTINGS: []
				# PRIVATE: [Active, Frequency]
				# IN: []
				# OUT: [Active, Frequency]
				ports_out[0] = float(input_active)
				ports_out[1] = input_frequency

			ModuleType.OUTPUT:
				# SETTINGS: []
				# PRIVATE: [Audio]
				# IN: [Audio]
				# OUT: []
				private[0] = modules [ports_in[0][0]] [4] [ports_in[0][1]]

			ModuleType.OSCILLATOR:
				# SETTINGS: [Waveform {SINE, SAW, TRIANGLE, SQUARE}]
				# PRIVATE: [Phase]
				# IN: [Frequency]
				# OUT: [Audio]
				var freq : float = modules [ports_in[0][0]] [4] [ports_in[0][1]]
				var phase : float = private[0]
				
				phase += freq * delta
				phase = fmod(phase, 1.0)
				private[0] = phase
				
				var output : float = sin(TAU * phase)
				
				ports_out[0] = output

			ModuleType.ENVELOPE:
				# SETTINGS: [A, D, S, R, V]
				# PRIVATE: [Output, State {IDLE, ATTACK, DECAY, SUSTAIN, RELEASE}]
				# IN: [Active]
				# OUT: [Output]
				var attack : float = settings[0]
				var decay : float = settings[1]
				var sustain : float = settings[2]
				var release : float = settings[3]
				var velocity : float = settings[4]
				
				var output : float = private[0]
				var state : int = int(private[1])
				
				var active : bool = bool( modules [ports_in[0][0]] [4] [ports_in[0][1]] )
				
				if active:
					if state == 0 or state == 4:
						state = 1
				elif state != 0 and state != 4:
					state = 4
				
				match state:
					0:
						output = 0.0
					1:
						output += delta / max(attack, 0.0001)
						if output >= velocity:
							output = velocity
							state = 2
					2:
						output -= delta * ((velocity - sustain) / max(decay, 0.0001))
						if output <= sustain:
							output = sustain
							state = 3
					3:
						output = sustain
					4:
						output -= delta / max(release, 0.0001)
						if output <= 0.0:
							output = 0.0
							state = 0
				private[0] = output
				private[1] = float(state)
				ports_out[0] = output

			ModuleType.ARITHMATIC:
				# SETTINGS: [OPERATION {ADD, SUBTRACT, MULTIPLY, DIVIDE}]
				# PRIVATE: []
				# IN: [Arg1, Arg2]
				# OUT: [Output]
				var operation : int = int(settings[0])
				var arg1 : float = modules [ports_in[0][0]] [4] [ports_in[0][1]]
				var arg2 : float = modules [ports_in[1][0]] [4] [ports_in[1][1]]
				var output : float
				match operation:
					0:
						output = arg1 + arg2
					1:
						output = arg1 - arg2
					2:
						output = arg1 * arg2
					3:
						output = arg1 / max(absf(arg2), 0.000001)
				ports_out[0] = output
	return modules[output_module][2][0]
