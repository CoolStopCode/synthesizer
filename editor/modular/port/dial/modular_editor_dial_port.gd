class_name ModularEditorDialPort
extends ModularEditorInputPort

@export var minimum_value : float
@export var maximum_value : float
@export var minimum_rotation : float
@export var maximum_rotation : float
@export var rotation_speed : float
@export var dial_rotation : float

@export_group("private")
@export var hole_disconnected_texture : Texture
@export var hole_connected_texture : Texture
@export var rim_disconnected_texture : Texture
@export var rim_connected_texture : Texture
@export var body_connected_texture : Texture
@export var body_disconnected_texture : Texture

@export var outline_node : TextureRect
@export var notch_node : TextureRect

var previous_mouse_position : Vector2
var dragging : bool = false

func clicked() -> void:
	previous_mouse_position = get_global_mouse_position()
	dragging = true

func connected() -> void:
	hole_node.texture = hole_connected_texture
	rim_node.texture = rim_connected_texture
	body_node.texture = body_connected_texture
	notch_node.hide()

func disconnected() -> void:
	hole_node.texture = hole_disconnected_texture
	rim_node.texture = rim_disconnected_texture
	body_node.texture = body_disconnected_texture
	notch_node.show()

func update_color(highlighted : bool) -> void:
	super.update_color(highlighted)
	
	var modular_editor_port_color : ModularEditorPortColor = color_table[color] 
	
	var black := modular_editor_port_color.black_color
	var dark := modular_editor_port_color.dark_color
	var medium := modular_editor_port_color.medium_color
	var light := modular_editor_port_color.light_color
	var highlight := modular_editor_port_color.highlight_color
	
	notch_node.self_modulate = black
	outline_node.self_modulate = dark

func _ready() -> void:
	super._ready()
	dial_rotation = deg_to_rad(dial_rotation)
	notch_node.rotation = clamp(dial_rotation, deg_to_rad(minimum_rotation), deg_to_rad(maximum_rotation))

func _input(event: InputEvent) -> void:
	if not dragging: return
	
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		dial_rotation += (event.global_position - previous_mouse_position).x * rotation_speed
		previous_mouse_position = event.global_position
		notch_node.rotation = clamp(dial_rotation, deg_to_rad(minimum_rotation), deg_to_rad(maximum_rotation))
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if not event.is_pressed():
			dragging = false
			dial_rotation = clamp(dial_rotation, deg_to_rad(minimum_rotation), deg_to_rad(maximum_rotation))

func get_value() -> float:
	var progress := inverse_lerp(minimum_rotation, maximum_rotation, rad_to_deg(dial_rotation))
	var value := lerpf(minimum_value, maximum_value, progress)
	value = clamp(value, minimum_value, maximum_value)
	
	return value
