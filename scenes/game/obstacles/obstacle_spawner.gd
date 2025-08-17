extends Node2D

@export var bounds_x: float
@export var slots: int = 12
@export var obstacles: Array[Obstacle]

var previous_distance: float

var rng = RandomNumberGenerator.new()
var positions: Array = []

func _ready() -> void:
	rng.randomize()
	refill_positions()
	for obstacle in obstacles:
		start_spawn_timer(obstacle)
		if obstacle.prefill: 
			spawn_new_obstacle(obstacle, true)

func spawn_new_obstacle(obstacle: Obstacle, prefill: bool = false) -> void:
	var amount = randi_range(obstacle.min_spawn_amount, obstacle.max_spawn_amount)
	for i in range(amount):
		if positions.is_empty():
			refill_positions()
		var obs = obstacle.prefab.instantiate()
		obs.position.x = positions.pop_front()
		add_child(obs)
		if prefill:
			obs.randomize_y_pos()

	if not prefill:
		start_spawn_timer(obstacle)

func start_spawn_timer(obstacle: Obstacle) -> void:
	var min_spawn_delay = obstacle.min_spawn_delay
	var max_spawn_delay = obstacle.max_spawn_delay
	obstacle.delay_left = rng.randf_range(min_spawn_delay, max_spawn_delay)

func refill_positions() -> void:
	positions.clear()
	for i in range(slots):
		var x = lerp(-bounds_x, bounds_x, float(i) / float(slots - 1))
		positions.append(x)
	positions.shuffle()


func _process(_delta: float) -> void:
	if not GameManager.game_started: 
		return

	for obstacle in obstacles: 
		obstacle.delay_left -= GameManager.distance_travelled - previous_distance
		if obstacle.delay_left <= 0: 
			spawn_new_obstacle(obstacle)
	previous_distance = GameManager.distance_travelled
