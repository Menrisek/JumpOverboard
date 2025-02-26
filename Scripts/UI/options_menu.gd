extends Control
class_name OptionsMenu

@onready var resolutions = $"Choosing Menu/Video/MarginContainer/VBoxContainer/Resolutions"

func _on_exit_button_pressed():
	GameManager.load_main_menu()

#zesílení
func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
	
#mute
func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)

#rozlišení
func _on_resolutions_item_selected(index):
	var resolution: String = resolutions.get_item_text(index)
	var h_resolution: int = int(resolution.get_slice("x", 0))
	var v_resolution: int = int(resolution.get_slice("x", 1))
	DisplayServer.window_set_size(Vector2i(h_resolution, v_resolution))
