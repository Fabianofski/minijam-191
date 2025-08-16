extends Area2D

var mouse_pos: Vector2
var diff: Vector2

@export var bounds: float
@export var speed: float

@onready var balloon_graphics: Node2D = $balloon
@onready var balloon_shader: TextureRect = $"balloon/balloon graphics"

@onready var line_l: Line2D = $LineL
@onready var line_r: Line2D = $LineR

@onready var attach_l: Node2D = $"balloon/balloon graphics/AttachL"
@onready var attach_r: Node2D = $"balloon/balloon graphics/AttachR"

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = get_global_mouse_position()
		diff = (mouse_pos - global_position).normalized()

func _process(delta: float) -> void:
	var blow_strength = MicControl.get_blow_strength()
	position.x -= diff.x * speed * delta * blow_strength
	position.x = clamp(position.x, -bounds, bounds)
	# Balloon rotation and movement
	balloon_graphics.look_at((get_local_mouse_position().rotated(PI/2)) * -1)
	balloon_shader.material.set_shader_parameter("speed", 20.0 + abs(MicControl.get_blow_strength()))
	# String
	line_l.set_point_position(1, attach_l.position)
	line_r.set_point_position(1, attach_r.position)

func _on_body_entered(_body: Node2D) -> void:
	SignalBus.game_over.emit()
