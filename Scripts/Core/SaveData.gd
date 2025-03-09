extends Resource
class_name SaveData

#nefunguje
@export var game_data = {
	"fullscreen_on": false,
	"vsync_on": false,
	"display_fps": false,
	"max_fps": 0,
	"bloom_on": false,
	"brightness": 1,
	"master_vol": -10,
	"music_vol": -10,
	"sfx_vol": -10,
	"fov": 70,
	"mouse_sens": 0.1,
}

@export var level_dictionary = {
	"Level1" : {
		"unlocked" : true,
		"score" : 0,
		"max_score" : 0,
		"coins" : 0,
		"max_coins" : 0,
		"enemies_beaten" : 0,
		"max_enemies_beaten" : 0,
		"damage_taken" : 0,
		"deaths" : 0,
		"timer" : 0,
		"unlocks" : "Level2",
		"beaten" : false,
	}
}
