extends Node 

func start_game(): 
	GameManager.start_game()
	self.get_parent().visible = false
