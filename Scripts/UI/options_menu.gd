extends Control
class_name OptionsMenu

func _on_exit_button_pressed():
	GameManager.load_main_menu()

#zesílení
func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
	
#mute
func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)
