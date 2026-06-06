class_name OscillatorSound
extends GeneratorSound

@export var waveform : Waveform

@export var enabled : bool = true
@export var chord_note : int = 0
@export var octave_shift : int = 0
@export var semitone_shift : int = 0
@export var gain : float = 1.0

@export var frequency_parameter : ParameterSound
@export var gain_parameter : ParameterSound
