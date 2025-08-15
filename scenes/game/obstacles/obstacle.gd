extends Node2D

@export var destroy_bounds: float
@export var speed_multiplier: float
@export var randomize_speed: bool = true
@export var randomize_brightness: bool = false
@export var randomize_size: bool = false
@export var randomize_flip: bool = false

func _ready():
	var sprite = $Sprite2D
	if randomize_speed:
		speed_multiplier *= randf_range(0.6, 1.4)
	if randomize_brightness: 
		sprite.self_modulate.a = randf_range(0.5, 1.0)
	if randomize_size: 
		sprite.scale *= randf_range(0.6, 1.4)
	if randomize_flip: 
		sprite.flip_h = randf() < 0.5

func _process(delta: float) -> void:
	position.y -= delta * speed_multiplier

	if global_position.y <= destroy_bounds: 
		queue_free()
