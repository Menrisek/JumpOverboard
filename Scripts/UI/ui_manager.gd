extends CanvasLayer
class_name Uimanager

func _ready():
	GameManager.pause_menu = $PauseMenu
	GameManager.win_screen = $WinScreen
	GameManager.score_label = $WinScreen/Score
	GameManager.death_label =$"WinScreen/Death counter"
	GameManager.coin_label = $"WinScreen/Coin counter"
	
	GameManager.gained_coins.connect(update_coin_display)

func _process(_delta):
	if Input.is_action_just_pressed("showmenu"):
		GameManager.pause_play()
		get_tree().paused = GameManager.paused

func update_coin_display(_gained_coins):
	$CoinDisplay.text = str(GameManager.coins)

#pause menu
func _on_resume_pressed():
	GameManager.resume()

func _on_restart_pressed():
	GameManager.restart()

func _on_world_map_pressed():
	GameManager.load_world()

func _on_main_menu_pressed():
	GameManager.load_main_menu()

func _on_quit_pressed():
	GameManager.quit()


func _on_finish_level_pressed():
	GameManager.load_world()
