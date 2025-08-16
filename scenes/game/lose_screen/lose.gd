extends Control

func _init():
	SignalBus.game_over.connect(game_over)

func game_over(): 
	GameManager.reset()
	self.visible = true

func restart(): 
	get_tree().reload_current_scene()
