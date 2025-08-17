extends Control

@onready var label: Label = $Label
@onready var high_score: Label = $"High Score"

func _init():
	SignalBus.game_over.connect(game_over)

func game_over(): 
	GameManager.reset()
	label.text = "You fell for "+str(int(GameManager.distance_travelled))+" metres!"
	high_score.text = "And yes! It's a high score." if GameManager.distance_travelled >= GameManager.highscore else "(And your high score is "+str(int(GameManager.highscore))+" metres.)"
	self.visible = true

func restart(): 
	get_tree().reload_current_scene()
