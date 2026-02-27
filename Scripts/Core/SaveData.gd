extends Resource
class_name SaveData

@export var total_coins : int = 0
@export var spent_coins : int = 0
@export var unlocked_abilities : Array[String] = []

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
