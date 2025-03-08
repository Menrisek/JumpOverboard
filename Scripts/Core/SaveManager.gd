extends Node

var save_path = "user://Saves/"
var save_name = "save1.tres"

var save_data = SaveData.new()

func save_game():
	#přepisuje level_dictionary v Level data
	DirAccess.make_dir_absolute(save_path)
	save_data.level_dictionary = LevelData.level_dictionary
	ResourceSaver.save(save_data, save_path + save_name)

func save_exists():
	return FileAccess.file_exists(save_path + save_name)

func load_game():
	save_data = ResourceLoader.load(save_path + save_name).duplicate(true)
	LevelData.level_dictionary = save_data.level_dictionary
	#ten to naopak loaduje
