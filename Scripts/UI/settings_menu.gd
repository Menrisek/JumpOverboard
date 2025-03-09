extends Popup
class_name SettingsMenu

#video settings
@onready var fullscreen_btn = $SettingsTabs/Video/MarginContainer/VideoSettings/FullscreenButton
@onready var vsync_btn = $SettingsTabs/Video/MarginContainer/VideoSettings/VsyncButton
@onready var display_fps_btn = $SettingsTabs/Video/MarginContainer/VideoSettings/DisplayFPSButton
@onready var max_fps_val = $SettingsTabs/Video/MarginContainer/VideoSettings/MaxFPSOptions/MaxFPSVal
@onready var max_fps_slider = $SettingsTabs/Video/MarginContainer/VideoSettings/MaxFPSOptions/MaxFPSSlider
@onready var bloom_btn = $SettingsTabs/Video/MarginContainer/VideoSettings/BloomButton
@onready var brightness_slider = $SettingsTabs/Video/MarginContainer/VideoSettings/BrightnessSlider

#audio settings
@onready var master_slider = $SettingsTabs/Audio/MarginContainer/AudioSettings/MasterVolSlider
@onready var music_slider = $SettingsTabs/Audio/MarginContainer/AudioSettings/MusicVolSlider
@onready var sfx_slider = $SettingsTabs/Audio/MarginContainer/AudioSettings/SfxVolSlider

func _ready():
	fullscreen_btn.button_pressed = LevelData.game_data.fullscreen_on
	vsync_btn.button_pressed = LevelData.game_data.vsync_on
	display_fps_btn.button_pressed = LevelData.game_data.display_fps
	max_fps_slider.value = LevelData.game_data.max_fps
	bloom_btn.button_pressed = LevelData.game_data.bloom_on
	brightness_slider.value = LevelData.game_data.brightness
	
	master_slider.value = LevelData.game_data.master_vol


func _on_fullscreen_button_toggled(button_pressed):
	GlobalSettings.toggle_fullscreen(button_pressed)

func _on_vsync_button_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)

#CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE

func _on_bloom_button_toggled(button_pressed):
	GlobalSettings.toggle_bloom(button_pressed)


func _on_master_vol_slider_value_changed(value):
	GlobalSettings.update_master_vol(value)

func _on_music_vol_slider_value_changed(value):
	GlobalSettings.update_music_vol(value)

func _on_sfx_vol_slider_value_changed(value):
	GlobalSettings.update_SFX_vol(value)
