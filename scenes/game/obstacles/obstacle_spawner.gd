extends Node2D

@onready var obstacle = load("res://scenes/game/obstacles/obstacle.tscn")
@export var bounds_x: float
@export var slots: int = 12
@export var min_spawn_delay: float = 1.0
@export var max_spawn_delay: float = 3.0

var rng = RandomNumberGenerator.new()
var positions: Array = []
var spawn_timer: Timer

func _ready() -> void:
	rng.randomize()
	refill_positions()
	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(spawn_new_obstacle)
	start_spawn_timer()

func spawn_new_obstacle() -> void:
	if positions.is_empty():
		refill_positions()
	var obs = obstacle.instantiate()
	obs.position.x = positions.pop_front()
	add_child(obs)
	start_spawn_timer()

func start_spawn_timer() -> void:
	spawn_timer.wait_time = rng.randf_range(min_spawn_delay, max_spawn_delay)
	spawn_timer.start()

func refill_positions() -> void:
	positions.clear()
	for i in range(slots):
		var x = lerp(-bounds_x, bounds_x, float(i) / float(slots - 1))
		positions.append(x)
	positions.shuffle()
