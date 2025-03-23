extends Popup
class_name SettingsMenu

#audio settings
@onready var master_slider = $SettingsTabs/Audio/MarginContainer/AudioSettings/MasterVolSlider
@onready var music_slider = $SettingsTabs/Audio/MarginContainer/AudioSettings/MusicVolSlider
@onready var sfx_slider = $SettingsTabs/Audio/MarginContainer/AudioSettings/SfxVolSlider

func _ready():
	master_slider.value = LevelData.game_data.master_vol

func _on_master_vol_slider_value_changed(value):
	GlobalSettings.update_master_vol(value)

func _on_music_vol_slider_value_changed(value):
	GlobalSettings.update_music_vol(value)

func _on_sfx_vol_slider_value_changed(value):
	GlobalSettings.update_SFX_vol(value)
