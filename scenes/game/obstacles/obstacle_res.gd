extends Resource
class_name Obstacle

@export var prefab: PackedScene 
@export var min_spawn_delay: float 
@export var max_spawn_delay: float
@export var min_spawn_amount: int = 1
@export var max_spawn_amount: int = 1
@export var prefill: bool
var delay_left: float
