extends Label

var time_elapsed: float = 0.0

func _ready() -> void:
	SignalBus.game_start.connect(game_started)

func _process(delta: float) -> void:
	if not GameManager.game_started:
		return
	time_elapsed += delta
	update_label()

func update_label(): 
	var seconds = roundi(time_elapsed) % 60
	var minutes = roundi(time_elapsed / 60) 
	self.text = str(minutes)+"'"+str(seconds)+"''"

func game_started():
	self.visible = true
