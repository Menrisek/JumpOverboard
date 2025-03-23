extends Node

func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	LevelData.game_data.master_vol = vol

#CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE CELÉ NEFUNGUJE

func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	LevelData.game_data.music_vol = vol

func update_SFX_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	LevelData.game_data.sfx_vol = vol
