extends Node

var recording := false
var recorder: AudioEffectRecord
var recordings: Array[AudioStreamWAV] = []
var players: Array[AudioStreamPlayer] = []


func _ready() -> void:
	var bus_index := AudioServer.get_bus_index("Active")
	for i in AudioServer.get_bus_effect_count(bus_index):
		var effect := AudioServer.get_bus_effect(bus_index, i)
		if effect is AudioEffectRecord:
			recorder = effect
			break

	if recorder == null:
		recorder = AudioEffectRecord.new()
		AudioServer.add_bus_effect(bus_index, recorder)


func _input(_event: InputEvent) -> void:
	if not Input.is_action_just_pressed("Record"):
		return

	if recording:
		stop_recording()
	else:
		start_recording()


func start_recording() -> void:
	print("RECORD")
	recording = true
	recorder.set_recording_active(true)


func stop_recording() -> void:
	print("STOP")
	recording = false
	recorder.set_recording_active(false)

	await get_tree().process_frame

	var stream := recorder.get_recording()
	if stream == null:
		return

	recordings.append(stream)

	var player := AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.bus = "Background"
	player.finished.connect(player.play)
	player.play()

	players.append(player)
