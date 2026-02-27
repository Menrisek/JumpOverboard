extends Control
class_name ShopMenu

func _on_close_button_pressed() -> void:
	self.visible = false

func _on_buy_dash_button_pressed() -> void:
	var price = 1
	
	# 1. Už to má?
	if "Dash" in LevelData.unlocked_abilities:
		print("Dash již zakoupeno!")
		return
		
	# 2. Má na to peníze? (funkce z LevelData)
	if LevelData.get_available_coins() >= price:
		LevelData.spent_coins += price
		LevelData.unlocked_abilities.append("Dash")
		SaveManager.save_game() # ukládání
		print("Dash zakoupen!")
		
		# Tady si pak updatuju zobrazení mincí v UI
	else:
		print("Nemáš dostatek peněz!")


func _on_buy_knife_throw_button_pressed() -> void:
	var price = 2
	
	if "KnifeThrow" in LevelData.unlocked_abilities:
		print("Knife Throw již zakoupeno!")
		return
		
	if LevelData.get_available_coins() >= price:
		LevelData.spent_coins += price
		LevelData.unlocked_abilities.append("KnifeThrow")
		SaveManager.save_game()
		print("KnifeThrow zakoupen!")
		
	else:
		print("Nemáš dostatek peněz!")


func _on_buy_double_jump_button_pressed() -> void:
	pass # Replace with function body.


func _on_buy_wall_climb_button_pressed() -> void:
	pass # Replace with function body.
