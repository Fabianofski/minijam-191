extends Label

var time_elapsed: float = 0.0

func _ready() -> void:
	SignalBus.game_start.connect(game_started)

func _process(delta: float) -> void:
	if not GameManager.game_started:
		return
	time_elapsed += (delta * GameManager.current_speed * GameManager.vertical_blow) / 10
	update_label()

func update_label(): 
	self.text = "%dm" % time_elapsed

func game_started():
	self.visible = true
