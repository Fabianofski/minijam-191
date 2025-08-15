extends Node2D

@export var bounds_x: float
@export var slots: int = 12
@export var obstacles: Array[Obstacle]

var rng = RandomNumberGenerator.new()
var positions: Array = []

func _ready() -> void:
	rng.randomize()
	refill_positions()
	for obstacle in obstacles:
		var spawn_timer = Timer.new()
		spawn_timer.one_shot = true
		add_child(spawn_timer)
		spawn_timer.timeout.connect(func(): spawn_new_obstacle(obstacle, spawn_timer))
		start_spawn_timer(obstacle, spawn_timer)

func spawn_new_obstacle(obstacle: Obstacle, spawn_timer: Timer) -> void:
	if positions.is_empty():
		refill_positions()
	var obs = obstacle.Prefab.instantiate()
	obs.position.x = positions.pop_front()
	add_child(obs)
	start_spawn_timer(obstacle, spawn_timer)

func start_spawn_timer(obstacle: Obstacle, spawn_timer: Timer) -> void:
	var min_spawn_delay = obstacle.Min_spawn_delay
	var max_spawn_delay = obstacle.Max_spawn_delay
	spawn_timer.wait_time = rng.randf_range(min_spawn_delay, max_spawn_delay)
	spawn_timer.start()

func refill_positions() -> void:
	positions.clear()
	for i in range(slots):
		var x = lerp(-bounds_x, bounds_x, float(i) / float(slots - 1))
		positions.append(x)
	positions.shuffle()
