extends TextureRect

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= 0.75: # If half a second has passed...
		self.rotation_degrees = randf_range(-4.8, 10.5)
		self.flip_h = randf() < 0.5
		time_elapsed = 0.0
