extends Control
class_name ShopMenu

func _on_close_button_pressed() -> void:
	self.visible = false

func _on_buy_dash_button_pressed() -> void:
	var price = 40
	
	# 1. Už to má?
	if "Dash" in LevelData.unlocked_abilities:
		print("Dash již zakoupeno!")
		return
		
	# 2. Má na to peníze? (funkce get_available_coins() z LevelData)
	if LevelData.get_available_coins() >= price:
		LevelData.spent_coins += price
		LevelData.unlocked_abilities.append("Dash")
		SaveManager.save_game() # ukládání
		print("Dash zakoupen!")
		#update zobrazení na mapě kolik mám coinů
		get_tree().current_scene.update_coin_display()
		
		# Tady si pak updatuju zobrazení mincí v UI
	else:
		print("Nemáš dostatek peněz!")


func _on_buy_knife_throw_button_pressed() -> void:
	var price = 100
	
	if "KnifeThrow" in LevelData.unlocked_abilities:
		print("Knife Throw již zakoupeno!")
		return
		
	if LevelData.get_available_coins() >= price:
		LevelData.spent_coins += price
		LevelData.unlocked_abilities.append("KnifeThrow")
		SaveManager.save_game()
		print("Knife Throw zakoupen!")
		get_tree().current_scene.update_coin_display()
		
	else:
		print("Nemáš dostatek peněz!")


func _on_buy_double_jump_button_pressed() -> void:
	var price = 80
	
	if "DoubleJump" in LevelData.unlocked_abilities:
		print("Double Jump již zakoupeno!")
		return
		
	if LevelData.get_available_coins() >= price:
		LevelData.spent_coins += price
		LevelData.unlocked_abilities.append("DoubleJump")
		SaveManager.save_game()
		print("Double Jump zakoupen!")
		get_tree().current_scene.update_coin_display()
		
	else:
		print("Nemáš dostatek peněz!")


func _on_buy_wall_climb_button_pressed() -> void:
	var price = 120
	
	if "WallClimb" in LevelData.unlocked_abilities:
		print("Wall Climb již zakoupeno!")
		return
		
	if LevelData.get_available_coins() >= price:
		LevelData.spent_coins += price
		LevelData.unlocked_abilities.append("WallClimb")
		SaveManager.save_game()
		print("Wall Climb zakoupen!")
		get_tree().current_scene.update_coin_display()
		
	else:
		print("Nemáš dostatek peněz!")
