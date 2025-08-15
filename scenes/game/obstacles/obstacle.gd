extends Node2D

@export var destroy_bounds: float
@export var speed_multiplier: float 

func _process(delta: float) -> void:
	position.y -= delta * speed_multiplier

	if global_position.y <= destroy_bounds: 
		queue_free()
