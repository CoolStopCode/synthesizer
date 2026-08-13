class_name ModularEditorPortData
extends Resource

enum PortShape {
	INPUT,
	OUTPUT
}

enum PortType {
	FLOAT,
	AUDIO,
	BOOL
}

@export var port_shape : PortShape
@export var port_type : PortType

@export var hole_color : Color
@export var highlight_color : Color
@export var outside_color : Color
@export var outline_color : Color

@export var hole_texture : Texture
@export var highlight_texture : Texture
@export var outside_texture : Texture
@export var outline_texture : Texture

func is_input_port():
	return port_shape == PortShape.INPUT

func is_output_port():
	return port_shape == PortShape.OUTPUT
