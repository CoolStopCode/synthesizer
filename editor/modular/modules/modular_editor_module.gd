@abstract class_name ModularEditorModule
extends Control

signal port_pressed(port : ModularEditorPort)
signal port_released(port : ModularEditorPort)

@export var ports : Array[ModularEditorPort]

func build():
	for port in ports:
		port.pressed.connect(port_pressed.emit.bind(port))
		port.released.connect(port_released.emit.bind(port))
