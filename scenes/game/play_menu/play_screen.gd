extends Node 

@onready var highscore_label: Label = $"Title/Highscore"

func _ready() -> void:
	highscore_label.visible = GameManager.highscore != 0
	highscore_label.text = "Highscore: %dm" % GameManager.highscore

func start_game(): 
	GameManager.start_game()
	self.visible = false
