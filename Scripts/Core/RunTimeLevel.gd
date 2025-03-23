extends Node
class_name RunTimeLevel

@onready var level_name = name
@onready var player = $Player

@export var level_title : String
@export var show_hp = true

var max_score = 0
var max_coins = 0
var max_enemies = 0

func _ready():
	#resetuji staty na 0 po dohrání lvlu, když budu chtít udělat celkové coiny nebo celkový počet smrtí
	#tak to jen nebudu nulovat a ono se to bude přičítat až do konce dohrání
	GameManager.coins = 0
	GameManager.score = 0
	GameManager.enemies_beaten = 0
	GameManager.damage_taken = 0
	GameManager.deaths = 0
	GameManager.speedrun_time = 0
	GameManager.level_beaten.connect(beat_level)
	set_values()

func set_values():
	for node in get_children():
		if node is Coin or node is Chest:
			max_score += node.score
			max_coins += node.coins
		if node is Sharkie: # KANÓN NENÍ ENEMY TAKŽE NEPOTŘEBUJI HO PŘIČÍTAT or node is Cannon:
			max_score += node.score
			max_enemies +=1
		if node is Cannon: # also dává 0 skóre, ale to ještě možná změním
			max_score += node.score

func beat_level():
	LevelData.generate_level(LevelData.level_dictionary[level_name]["unlocks"])
	#přistupujem do dictionary a předělávám unlocked na true
	LevelData.level_dictionary[LevelData.level_dictionary[level_name]["unlocks"]]["unlocked"] = true
	
	LevelData.update_level(level_name, GameManager.score,max_score, GameManager.coins, max_coins, GameManager.enemies_beaten, max_enemies, GameManager.damage_taken, GameManager.deaths, GameManager.speedrun_time, true)
	SaveManager.save_game()
