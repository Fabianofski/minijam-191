extends Node2D

var current_speed: float = 0 
var vertical_blow: float = 0
var game_started: bool = false

func _process(delta: float) -> void:
	if not game_started: 
		return
	current_speed += delta 

func start_game(): 
	game_started = true
	current_speed = 80
	SignalBus.game_start.emit()

func reset():
	game_started = false 
	current_speed = 0
