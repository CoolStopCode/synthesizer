class_name VoiceProperties
extends Resource

@export var waveforms : Array[Waveform.Enum] = [
	Waveform.Enum.SINE,
	Waveform.Enum.SINE,
	Waveform.Enum.SINE,
	Waveform.Enum.SINE
]

@export var layer_enable : Array[bool]  = [false, false, false, false]
@export var layer_octave  : Array[int]  = [-1   , -1   , -1   , -1   ]
@export var layer_gain   : Array[float] = [0.5  , 0.5  , 0.5  , 0.5  ]

@export var note_enable : Array[bool]   = [true , true , true , true ]
@export var note_octave  : Array[int]   = [0    , 0    , 0    , 0    ]
@export var note_gain   : Array[float]  = [0.5  , 0.5  , 0.5  , 0.5  ]
