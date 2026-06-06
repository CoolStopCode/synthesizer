extends Control

var recording := false

var recorder: AudioEffectRecord
var recordings: Array[AudioStreamWAV] = []
var players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	# Add a Record effect to the Master bus if it doesn't exist
	var master_bus := AudioServer.get_bus_index("Active")

	for i in AudioServer.get_bus_effect_count(master_bus):
		var effect := AudioServer.get_bus_effect(master_bus, i)
		if effect is AudioEffectRecord:
			recorder = effect
			break

	if recorder == null:
		recorder = AudioEffectRecord.new()
		AudioServer.add_bus_effect(master_bus, recorder)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Record"):
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

	if stream:
		var player := AudioStreamPlayer.new()
		add_child(player)
		
		player.stream = stream
		player.finished.connect(func():
			player.play()
		)

		player.stream = stream
		player.bus = "Background"
		player.play()
