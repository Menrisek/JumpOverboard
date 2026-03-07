extends Control
class_name ShopMenu

@export_category("Prices")
@export var dash_price :int = 40
@export var knife_throw_price :int = 100
@export var double_jump_price :int = 80
@export var wall_climb_price :int = 120

@onready var buy_dash_button = $PauseMenu/GridContainer/DashVBoxContainer/BuyDashButton
@onready var buy_knife_throw_button = $PauseMenu/GridContainer/KnifeVBoxContainer/BuyKnifeThrowButton
@onready var buy_double_jump_button = $PauseMenu/GridContainer/DoubleJumpVBoxContainer/BuyDoubleJumpButton
@onready var buy_wall_climb_button = $PauseMenu/GridContainer/WallClimbBoxContainer/BuyWallClimbButton

func _ready():
	# pokud se shop právě ukazuje, tak se mi updatně uiko (ceny, zešdnutí atd.)
	visibility_changed.connect(_on_visibility_changed)
	update_shop_ui()


func _on_close_button_pressed() -> void:
	self.visible = false

func _on_buy_dash_button_pressed() -> void:
	var price = dash_price
	
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
	var price = knife_throw_price
	
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
	var price = double_jump_price
	
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
	var price = wall_climb_price
	
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

func _on_visibility_changed():
	if visible:
		update_shop_ui()

func update_shop_ui():
	buy_dash_button.text = str(dash_price) # napíše to aktuální cenu z inspektoru
	buy_knife_throw_button.text = str(knife_throw_price)
	buy_double_jump_button.text = str(double_jump_price)
	buy_wall_climb_button.text = str(wall_climb_price)
	
	if "Dash" in LevelData.unlocked_abilities:
		buy_dash_button.disabled = true # Zešedne to
		buy_dash_button.tooltip_text = "Already purchased" # Text po najetí myší
	else:
		buy_dash_button.disabled = false
		buy_dash_button.tooltip_text = ""
		
	if "KnifeThrow" in LevelData.unlocked_abilities:
		buy_knife_throw_button.disabled = true
		buy_knife_throw_button.tooltip_text = "Already purchased"
	else:
		buy_knife_throw_button.disabled = false
		buy_knife_throw_button.tooltip_text = ""

	if "DoubleJump" in LevelData.unlocked_abilities:
		buy_double_jump_button.disabled = true
		buy_double_jump_button.tooltip_text = "Already purchased"
	else:
		buy_double_jump_button.disabled = false
		buy_double_jump_button.tooltip_text = ""

	if "WallClimb" in LevelData.unlocked_abilities:
		buy_wall_climb_button.disabled = true
		buy_wall_climb_button.tooltip_text = "Already purchased"
	else:
		buy_wall_climb_button.disabled = false
		buy_wall_climb_button.tooltip_text = ""
