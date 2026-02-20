extends Node

const SETTINGS_PATH := "user://settings.cfg"

var master_bus := AudioServer.get_bus_index("Master")
var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

var master := 1.0
var music := 1.0
var sfx := 1.0


func _ready():
	load_settings()
	apply_settings()


# =============================
# LOAD
# =============================

func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)

	if err != OK:
		print("No settings file found, using defaults")
		return

	master = config.get_value("audio", "master", 1.0)
	music = config.get_value("audio", "music", 1.0)
	sfx = config.get_value("audio", "sfx", 1.0)

	print("Audio settings loaded")


# =============================
# SAVE
# =============================

func save_settings():
	var config = ConfigFile.new()

	config.set_value("audio", "master", master)
	config.set_value("audio", "music", music)
	config.set_value("audio", "sfx", sfx)

	config.save(SETTINGS_PATH)

	print("Audio settings saved")


# =============================
# APPLY
# =============================

func apply_settings():
	set_master(master)
	set_music(music)
	set_sfx(sfx)


# =============================
# SETTERS
# =============================

func set_master(value):
	master = value
	AudioServer.set_bus_volume_db(master_bus, safe_linear_to_db(value))

func set_music(value):
	music = value
	AudioServer.set_bus_volume_db(music_bus, safe_linear_to_db(value))

func set_sfx(value):
	sfx = value
	AudioServer.set_bus_volume_db(sfx_bus, safe_linear_to_db(value))


# =============================
# HELPER
# =============================

func safe_linear_to_db(value):
	if value <= 0.01:
		return -80
	return linear_to_db(value)
