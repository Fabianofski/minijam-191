extends Node

@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sound_bus = AudioServer.get_bus_index("Sound")

@onready var music_slider: HSlider = $"MusicSlider"
@onready var sound_slider: HSlider = $"SoundSlider"

func update_sliders():
	music_slider.value = AudioServer.get_bus_volume_linear(music_bus)
	sound_slider.value = AudioServer.get_bus_volume_linear(sound_bus)

func set_sound_volume(value: float):
	AudioServer.set_bus_volume_linear(sound_bus, value)

func set_music_volume(value: float):
	AudioServer.set_bus_volume_linear(music_bus, value)
