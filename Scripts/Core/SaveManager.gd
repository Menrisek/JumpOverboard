extends Node

var save_path = "user://Saves/"
var save_name = "save1.tres"

var save_data = SaveData.new()

func save_game():
	DirAccess.make_dir_absolute(save_path)
	
	save_data.level_dictionary = LevelData.level_dictionary
	
	#řešení shopu
	save_data.total_coins = LevelData.total_coins
	save_data.spent_coins = LevelData.spent_coins
	save_data.unlocked_abilities = LevelData.unlocked_abilities
	
	ResourceSaver.save(save_data, save_path + save_name)
	print("Game saved")

func save_exists():
	return FileAccess.file_exists(save_path + save_name)

func load_game():
	save_data = ResourceLoader.load(save_path + save_name).duplicate(true)
	
	LevelData.level_dictionary = save_data.level_dictionary
	# načítání uložených coinů
	if "total_coins" in save_data:
		LevelData.total_coins = save_data.total_coins 
	if "spent_coins" in save_data:
		LevelData.spent_coins = save_data.spent_coins
	if "unlocked_abilities" in save_data:
		LevelData.unlocked_abilities = save_data.unlocked_abilities
	
	print("Game loaded")
