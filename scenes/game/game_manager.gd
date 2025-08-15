extends Node2D

var current_speed: float = 80 

func _process(delta: float) -> void:
	current_speed += delta
