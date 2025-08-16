extends Label

var time_elapsed: float = 0.0
var minutes: int = 0
var seconds: int = 0

func _process(delta: float) -> void:
	self.text = str(minutes)+"'"+str(seconds)+"''"
	if time_elapsed < 1.0:
		time_elapsed += delta
	else:
		time_elapsed = 0
		seconds += 1
		if seconds >= 60:
			seconds = 0
			minutes += 1
