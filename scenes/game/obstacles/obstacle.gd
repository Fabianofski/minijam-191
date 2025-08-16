extends Node2D

@export var destroy_bounds: float
@export var speed_multiplier: Vector2 = Vector2(0, 1)
@export var randomize_speed: bool = true
@export var randomize_brightness: bool = false
@export var randomize_size: bool = false
@export var randomize_flip: bool = false

@onready var sprite = $Sprite2D

func _ready():
	if randomize_speed:
		speed_multiplier *= randf_range(0.6, 1.4)
	if randomize_brightness: 
		sprite.self_modulate.a = randf_range(0.5, 1.0)
	if randomize_size: 
		var _scale = randf_range(0.6, 1.4)
		sprite.scale *= _scale
	if randomize_flip: 
		sprite.flip_h = randf() < 0.5
		if sprite.flip_h:
			speed_multiplier.x = -speed_multiplier.x
		#wing.flip_h = sprite.flip_h ALERT: Somehow broken!!!

func _process(delta: float) -> void:
	position.y -= delta * GameManager.current_speed * speed_multiplier.y
	position.x -= delta * speed_multiplier.x 

	if global_position.y <= destroy_bounds: 
		queue_free()
