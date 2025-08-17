extends Node2D

@onready var game_music: AudioStreamPlayer = $"GameMusic"
@onready var main_menu_music: AudioStreamPlayer = $"MainMenu"

func _ready() -> void:
	SignalBus.game_over.connect(func(): switch_track("Menu"))
	SignalBus.game_start.connect(func(): switch_track("Game"))
	switch_track("Menu")

func switch_track(track: String): 
	match track:
		"Menu": 
			fade("Game", false)
			fade("Menu", true)
		"Game": 
			fade("Game", true)
			fade("Menu", false)

func fade(track: String, fade_in: bool): 
	var player = game_music if track == "Game" else main_menu_music
	if fade_in: 
		player.play()

	var target_volume = 1 if fade_in else 0
	var tween_time = 0.5 if fade_in else 0.2 

	var tween = get_tree().create_tween()
	tween.tween_property(player, "volume_linear", target_volume, tween_time)
	tween.set_ease(Tween.EASE_OUT)

	await tween.finished

	if not fade_in:
		player.stop()
