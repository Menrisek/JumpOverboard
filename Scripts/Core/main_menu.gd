extends Control
class_name MainMenu

@onready var sfx_hover = $"SFX Hover"
@onready var sfx_select = $"SFX Select"

func _ready():
	for child in get_all_children(self):
		if child is Button:
			child.mouse_entered.connect(_play_hover_sound)
			child.pressed.connect(_play_click_sound)
	$VBoxContainer/Start.grab_focus()
	
	#vytvoří/uloží save po zapnutí main menu + chekuje jestli existuje už save (pokud ne, tak ho vytvoří)
	if not SaveManager.save_exists():
		SaveManager.save_game()
	
	#zapne look soundtracku potom co dohraje intro soundtracku
	await get_tree().create_timer(21.18).timeout
	$"Main Menu Soundtrack - loop".play()

func _on_start_pressed():
	#než hru spustím, zajistím načtení dat z savu
	if SaveManager.save_exists():
		SaveManager.load_game()

	get_tree().change_scene_to_file("res://Scenes/WorldScenes/Level1.tscn")

func _on_load_pressed():
	SaveManager.load_game()

func _on_options_pressed():
	get_node("SettingsMenu").visible = true

func _on_world_map_pressed():
	_play_click_sound()
	await get_tree().create_timer(0.1).timeout
	GameManager.load_world()

func _on_quit_pressed():
	GameManager.quit()

func get_all_children(node) -> Array:
	var nodes : Array = []
	for child in node.get_children():
		nodes.append(child)
		if child.get_child_count() > 0:
			nodes += get_all_children(child)
	return nodes

func _play_hover_sound():
	sfx_hover.pitch_scale = randf_range(0.9, 1.1)
	sfx_hover.play()

func _play_click_sound():
	sfx_select.play()
