extends Node2D

@export var destroy_bounds: float
@export var destroy_bounds_x: float
@export var speed_multiplier: Vector2 = Vector2(0, 1)
@export var randomize_speed: bool = true
@export var randomize_brightness: bool = false
@export var randomize_size: bool = false
@export var randomize_flip: bool = false
@export var start_on_the_sides: bool = false
@export var randomize_y: bool = false

@onready var sprite = $Sprite2D
@onready var shadow = $Shadow

func _ready():
	if randomize_speed:
		speed_multiplier *= randf_range(0.6, 1.4)
	if randomize_brightness: 
		sprite.self_modulate.a = randf_range(0.5, 1.0)
	if randomize_size: 
		var _scale = randf_range(0.6, 1.4)
		sprite.scale *= _scale
	var flip = false
	if randomize_flip: 
		flip = randf() < 0.5 
		if flip:
			sprite.scale.x = -1
			speed_multiplier.x = -speed_multiplier.x
	if start_on_the_sides: 
		if flip: 
			position.x = -destroy_bounds_x
		else: 
			position.x = destroy_bounds_x
	if randomize_y: 
		randomize_y_pos()
	# Set shadow to match sprite
	shadow.scale = sprite.scale
	shadow.scale.x = sprite.scale.x

func randomize_y_pos(): 
	global_position.y = randf_range(global_position.y, destroy_bounds)

func _process(delta: float) -> void:
	position.y -= delta * GameManager.current_speed * speed_multiplier.y * GameManager.vertical_blow
	position.x -= delta * speed_multiplier.x 

	if global_position.y <= destroy_bounds: 
		queue_free()
	if global_position.x < -destroy_bounds_x: 
		queue_free() 
	if global_position.x > destroy_bounds_x: 
		queue_free()
