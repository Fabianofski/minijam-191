extends Area2D

var mouse_pos: Vector2
var diff: Vector2

@export var bounds: float
@export var speed: float

@onready var balloon_graphics: Node2D = $balloon

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = get_global_mouse_position()
		diff = (mouse_pos - global_position).normalized()

func _process(delta: float) -> void:
	var blow_strength = MicControl.get_blow_strength()
	position.x -= diff.x * speed * delta * blow_strength
	position.x = clamp(position.x, -bounds, bounds)
	# Balloon rotation
	balloon_graphics.look_at((get_local_mouse_position().rotated(PI/2))*-1)

func _on_body_entered(_body: Node2D) -> void:
	SignalBus.game_over.emit()
