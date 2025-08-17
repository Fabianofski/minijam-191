extends Node

var config = ConfigFile.new()
const SAVE_FILE_PATH = "user://savefile.ini"

func _ready() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH) == true:
		config.load(SAVE_FILE_PATH)
	else:
		config.set_value("playerinfo", "highscore", 0)
		config.save(SAVE_FILE_PATH)

func save_to_file(value):
	config.set_value("playerinfo", "highscore", value)
	config.save(SAVE_FILE_PATH)

func load_from_file():
	config.load(SAVE_FILE_PATH) # For some reason you have to load it again here
	return config.get_value("playerinfo", "highscore", 0)

func reset_to_default():
	config.set_value("playerinfo", "highscore", 0)
	config.save(SAVE_FILE_PATH)
