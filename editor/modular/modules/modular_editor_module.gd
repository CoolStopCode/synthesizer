@abstract class_name ModularEditorModule
extends Control

signal port_up(port : ModularEditorPort)
signal port_down(port : ModularEditorPort)

@export var ports : Array[ModularEditorPort]

func build():
	for port in ports:
		port.port_down.connect(port_down.emit.bind(port))
		port.port_up.connect(port_up.emit.bind(port))
