extends Node

signal bloom_toggled(value)

func toggle_fullscreen(value):
	if value == true:
		DisplayServer.WINDOW_MODE_FULLSCREEN
	else:
		DisplayServer.WINDOW_MODE_MAXIMIZED
	print(value)

func toggle_vsync(value):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	print(value)

func toggle_bloom(value):
	emit_signal("bloom_toggled",value)

func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	LevelData.game_data.master_vol = vol
	SaveManager.save_game()

#CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE

func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	LevelData.game_data.music_vol = vol
	SaveManager.save_game()
	
func update_SFX_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	LevelData.game_data.sfx_vol = vol
	SaveManager.save_game()
