extends Node2D
class_name WorldMap

@onready var level_holder = $LevelHolder
@onready var player = $Player

var total_coins : int

var levels = []
@onready var curr_level = $LevelHolder/Level1

#Lineární interpolace (lerp) 
var lerp_speed = 0.5
var lerp_progress = 0.0
var completed_movement = true
var lerp_threshold = 0.1

func _ready():
	SaveManager.load_game()
	player.get_node("AnimationPlayer").play("idle")
	levels = level_holder.get_children()
	update_levels() 
	#vypíše celkový počet coinů do konzole
	for level in SaveManager.save_data.level_dictionary:
		total_coins += SaveManager.save_data.level_dictionary[level]["coins"]
		print("Total amount of coins: " + str(total_coins))
	#vypisuje to na mapu
	update_coin_display()

func update_levels():
	for level in levels:
		if level.name in LevelData.level_dictionary:
			#dívám se do dictionary zda je lvl odemknutý (unlocked), nebo poražený (beaten), nebo zamknutý (beaten)
			if LevelData.level_dictionary[level.name]["unlocked"] == true:
				level.get_node("Sprite2D").texture = load("res://Art/World Map/Unlocked.png")
				if LevelData.level_dictionary[level.name]["beaten"] == true:
					level.get_node("Sprite2D").texture = load("res://Art/World Map/Beaten.png")
			else:
				level.get_node("Sprite2D").texture = load("res://Art/World Map/Locked.png")

func _process(delta):
	var target_level : Node2D
	
	#mění target lvl podle toho kam se chci hýbat
	if Input.is_action_just_pressed("up"):
		if curr_level.up:
			target_level = curr_level.up
	if Input.is_action_just_pressed("down"):
		if curr_level.down:
			target_level = curr_level.down
	if Input.is_action_just_pressed("left"):
		if curr_level.left:
			target_level = curr_level.left
	if Input.is_action_just_pressed("right"):
		if curr_level.right:
			target_level = curr_level.right
	
	if Input.is_action_just_pressed("jump"):
		player.get_node("AnimationPlayer").play("select")
		await get_tree().create_timer(0.4).timeout
		#mění který level leadnu
		get_tree().change_scene_to_file("res://Scenes/WorldScenes/"+ curr_level.name + ".tscn")
	
	#safety checks
	if target_level and target_level.name in LevelData.level_dictionary and LevelData.level_dictionary[target_level.name]["unlocked"] and completed_movement:
		completed_movement = false
		player.get_node("AnimationPlayer").play("run")
		lerp_progress = 0.0
		while lerp_progress <1.0:
			lerp_progress += lerp_speed + delta
			lerp_progress = clamp(lerp_progress, 0.0, 1.0)
			player.position = player.position.lerp(target_level.global_position, lerp_progress)
			
			if player.position.distance_to(target_level.global_position) < lerp_threshold:
				break
			
			await get_tree().create_timer(delta).timeout
		player.position = target_level.global_position
		show_stats(target_level)
		curr_level = target_level
		player.get_node("AnimationPlayer").play("idle")
		completed_movement = true

#zobrazování statů
func show_stats(target_level):
	if LevelData.level_dictionary[target_level.name]["unlocked"]:
		target_level.get_node("StatsDisplay").visible = true
		target_level.get_node("StatsDisplay").get_node("AnimationPlayer").play("show")
	curr_level.get_node("StatsDisplay").get_node("AnimationPlayer").play("show",0, -1.0, true)
	
	#aby se jednotlivé ukazovali (jestli jsem vzal všechny coiny, jestli jsem zabyl všechny enemáky, a jestli jsem to dal nohit)
	#coiny
	if LevelData.level_dictionary[target_level.name]["coins"] == LevelData.level_dictionary[target_level.name]["max_coins"] and LevelData.level_dictionary[target_level.name]["score"] > 0:
		target_level.get_node("StatsDisplay").get_node("DisplayCoins").visible = true
	else:
		target_level.get_node("StatsDisplay").get_node("DisplayCoins").visible = false
	#enemáci
	if LevelData.level_dictionary[target_level.name]["enemies_beaten"] == LevelData.level_dictionary[target_level.name]["max_enemies_beaten"] and LevelData.level_dictionary[target_level.name]["score"] > 0:
		target_level.get_node("StatsDisplay").get_node("DisplayEnemies").visible = true
	else:
		target_level.get_node("StatsDisplay").get_node("DisplayEnemies").visible = false
	#nohit
	if LevelData.level_dictionary[target_level.name]["damage_taken"] == 0 and LevelData.level_dictionary[target_level.name]["score"] > 0:
		target_level.get_node("StatsDisplay").get_node("DisplayHits").visible = true
	else:
		target_level.get_node("StatsDisplay").get_node("DisplayHits").visible = false

#vypíše celkový počet coinů na mapě
func update_coin_display():
	$CanvasLayer/CoinDisplay.text = str(total_coins)

func _on_main_menu_pressed():
	GameManager.load_main_menu()
