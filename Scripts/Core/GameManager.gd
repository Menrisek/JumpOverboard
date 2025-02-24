extends Node

var current_checkpoint : Checkpoint
var player : Player
var damage_taken = 0

var coins : int = 0
var score : int = 0
var enemies_beaten : int = 0
var deaths : int = 0

var paused = false
var pause_menu
var win_screen
var score_label
var death_label
var coin_label
var speedrun_time_label

var speedrun_time = 0

signal gained_coins(int)
signal level_beaten()

func respawn_player():
	player.health = player.max_health
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func gain_coins(coins_gained:int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	print("Coin: " + str(coins))

func win():
	emit_signal("level_beaten")
	win_screen.visible = true
	#zobrazuje na winscreenu staty
	score_label.text = "Your Score: " + str(score)
	death_label.text = "Deaths " + str(deaths)
	coin_label.text = "Coins: " + str(coins)
	#zastaví se hra po 0.1 sec po dotknutí výherní vlajky
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = true
	speedrun_time_label.text = "Your Time: " + str(speedrun_time)

func pause_play():
	paused = !paused
	
	pause_menu.visible = paused

func resume():
	get_tree().paused = false
	pause_play()

func restart():
	#musí restartovat coiny a skóre
	coins = 0
	score = 0
	#kdyby lvl neměl checkpoint tak se budu snažit dostat na ten z předchozího
	current_checkpoint = null
	get_tree().reload_current_scene()
	get_tree().paused = false

func load_world():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/world_map.tscn")

func load_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/Main menu/main_menu.tscn")

func quit():
	get_tree().quit()
