extends Control

@onready var master_slider = $PauseMenu/VBoxContainer/MasterSlider
@onready var music_slider = $PauseMenu/VBoxContainer/MusicSlider
@onready var sfx_slider = $PauseMenu/VBoxContainer/SFXSlider


func _ready():
	master_slider.value = AudioManager.master
	music_slider.value = AudioManager.music
	sfx_slider.value = AudioManager.sfx


func _on_master_slider_value_changed(value):
	AudioManager.set_master(value)

func _on_music_slider_value_changed(value):
	AudioManager.set_music(value)

func _on_sfx_slider_value_changed(value):
	AudioManager.set_sfx(value)


func _on_apply_button_pressed():
	AudioManager.save_settings()


func _on_back_to_menu_button_pressed() -> void:
	GameManager.load_main_menu()
