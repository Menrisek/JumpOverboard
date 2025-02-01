extends Control
class_name MainMenu

func _ready():
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/Level1.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_world_map_pressed():
	GameManager.load_world()

func _on_quit_pressed():
	GameManager.quit()
