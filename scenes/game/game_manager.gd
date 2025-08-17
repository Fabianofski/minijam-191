extends Node2D

var current_speed: float = 0 
var vertical_blow: float = 0
var game_started: bool = false
var distance_travelled: float = 0
var highscore: float = 0

func _ready() -> void:
	highscore = SaveManager.load_from_file()

func _process(delta: float) -> void:
	if not game_started: 
		return
	current_speed += delta 
	distance_travelled += (delta * GameManager.current_speed * GameManager.vertical_blow) / 100

func start_game(): 
	game_started = true
	current_speed = 80
	distance_travelled = 0
	SignalBus.game_start.emit()

func reset():
	if distance_travelled > highscore: 
		highscore = distance_travelled
		SaveManager.save_to_file(highscore)
	game_started = false 
	current_speed = 0
