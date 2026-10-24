class_name AnalogAudio
extends TonalAudio

func process(delta : float) -> float:
	return 0.0

func build() -> void:
	super.build()

func key_pressed(index: int) -> void:
	pass

func key_released(index: int) -> void:
	pass

func bend_changed(new_bend : Vector3i) -> void:
	pass
