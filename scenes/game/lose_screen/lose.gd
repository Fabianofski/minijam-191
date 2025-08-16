extends Control

func _init():
	SignalBus.game_over.connect(game_over)

func game_over(): 
	self.visible = true

func restart(): 
	GameManager.reset()
	get_tree().reload_current_scene()
