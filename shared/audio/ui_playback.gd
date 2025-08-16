extends Node


var playback:AudioStreamPlaybackPolyphonic


func _enter_tree() -> void:
	var player = AudioStreamPlayer.new()
	add_child(player)

	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	playback = player.get_stream_playback()

	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	if node is Button:
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)


func _play_hover() -> void:
	pass
	playback.play_stream(preload('res://shared/audio/hover.wav'), 0, 0, randf_range(0.9, 1))


func _play_pressed() -> void:
	playback.play_stream(preload('res://shared/audio/button_press.wav'))
