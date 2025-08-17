extends Label

func _ready() -> void:
	SignalBus.game_start.connect(game_started)

func _process(_delta: float) -> void:
	if not GameManager.game_started:
		return
	update_label()

func update_label(): 
	self.text = "%dm" % GameManager.distance_travelled

func game_started():
	self.visible = true
