extends Node

#slovník co "ukládá" data
var level_dictionary = {
	#ve slovníku udělám další slovník
	"Level1" : {
		#funguje to trochu podobně jako kdybych napsal var unlocked = true
		"unlocked" : true,
		"score" : 0,
		"max_score" : 0,
		"coins" : 0,
		"max_coins" : 0,
		"enemies_beaten" : 0,
		"max_enemies_beaten" : 0,
		"damage_taken" : 0,
		"deaths" : 0,
		"unlocks" : "Level2",
		"beaten" : false,
	}
}

#automaticky se mu bude vytvářet dictionary, abych ho nemusel dělat manuálně
func generate_level(level):
	if level not in level_dictionary:
		#vytvářím nový dictionary
		level_dictionary[level] = {
			#unlocked jsem změnil na false nesmí být odemčený všechny lvly hned
			"unlocked" : false,
			"score" : 0,
			"max_score" : 0,
			"coins" : 0,
			"max_coins" : 0,
			"enemies_beaten" : 0,
			"max_enemies_beaten" : 0,
			"damage_taken" : 0,
			"deaths" : 0,
			"timer" : 0,
			"unlocks" : generate_level_number(level),
			"beaten" : false,
		}
#funkce pro vytvoření dalšího názvu lvlu (jako třeba Level2 a ten odemkne Level3 atd.) 
#použití výše v dictionary
func generate_level_number(level):
	var level_number = ""
	#projde to všechny charaktery v stringu výše (level_number)
	for character in level:
		#důvod proč je to v stringu a ne v int je takový, že kdyby to byl int tak
		#by to v případě lvlu 13 sečetlo 1+3 což nechci, chci aby to udělalo lvl 14
		if character.is_valid_int():
			level_number += character
	#předělám to na int tudíž se např. z int 13 stane int 14
	level_number = int(level_number) +1
	#a pak zpět na str abych to mohl přidat k Level
	return "Level" + str(level_number)

#funcke na updatování lvlů (datové typy jsou už předtím definované)
func update_level(level, score, max_score, coins, max_coins, enemies_beaten, max_enemies_beaten, damage_taken, deaths, timer, beaten):
	level_dictionary[level]["score"] = score
	level_dictionary[level]["max_score"] = max_score
	level_dictionary[level]["coins"] = coins
	level_dictionary[level]["max_coins"] = max_coins
	level_dictionary[level]["enemies_beaten"] = enemies_beaten
	level_dictionary[level]["max_enemies_beaten"] = max_enemies_beaten
	level_dictionary[level]["damage_taken"] = damage_taken
	level_dictionary[level]["deaths"] = deaths
	level_dictionary[level]["timer"] = timer
	level_dictionary[level]["beaten"] = beaten
	print(level_dictionary)
