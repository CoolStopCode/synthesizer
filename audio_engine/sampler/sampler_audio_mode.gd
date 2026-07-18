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
	var frequencies := sample.get_frequencies(10000, 11000)
	print(get_median(frequencies))

func get_median(values : Array[float]):
	var sorted_values = values.duplicate()
	sorted_values.sort()

	var size = sorted_values.size()
	var mid = size / 2

	if size % 2 == 0:
		return (sorted_values[mid - 1] + sorted_values[mid]) / 2.0
	else:
		return float(sorted_values[mid])

func key_pressed(index: int) -> void:
	pass

func key_released(index: int) -> void:
	pass

func bend_changed() -> void:
	pass
