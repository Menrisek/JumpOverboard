extends Control
class_name MainMenu


func _ready():
	$VBoxContainer/Start.grab_focus()
	
	#vytvoří/uloží save po zapnutí main menu + chekuje jestli existuje už save (pokud ne, tak ho vytvoří)
	if not SaveManager.save_exists():
		SaveManager.save_game()
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/Level1.tscn")

func _on_load_pressed():
	SaveManager.load_game()
	print("Game was loaded")

func _on_options_pressed():
	#GameManager.load_options_menu()
	#nefunguje
	$SettingsMenu.popup_centered()

func _on_world_map_pressed():
	GameManager.load_world()

func _on_quit_pressed():
	GameManager.quit()
