class_name SamplerAudioMode
extends TonalAudioMode

@export var sample : Sampler_Sample

var polyvoices : Array[Sampler_Polyvoice]

func process(delta : float) -> float:
	var sum: float = 0.0
	
	for polyvoice in polyvoices:
		sum += polyvoice.process(delta)
	
	return sum

func build() -> void:
	super.build()
	var frequency := sample.estimate_root_frequency(16000, 18000)
	print(frequency)

func key_pressed(index: int) -> void:
	pass

func key_released(index: int) -> void:
	pass

func bend_changed() -> void:
	pass
