extends Control
class_name StatsMenu

@onready var grid = $PauseMenu/GridContainer # Cesta k tvému GridContaineru

# Názvy našich 7 sloupců
var headers = ["Level Name", "Coins", "Hits Taken", "Deaths", "Enemies Beaten", "Score", "Time"]
var my_font = preload("res://Art/Fonts/PirateFont.ttf") # Sem dej svoji cestu

func _ready():
	# Opět použijeme náš trik: tabulka se updatne pokaždé, když ji ukážeš
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if visible:
		update_table()

func update_table():
	# 1. Vyčistíme starou tabulku (kdyby ji hráč otevřel podruhé)
	for child in grid.get_children():
		child.queue_free()
		
	# 2. Vytvoříme hlavičku (nadpisy)
	for text in headers:
		add_label(text)
		
	# 3. Získáme data pro Level 1 až 10 (můžeš si číslo zvýšit, pokud jich máš víc)
	for i in range(1, 11):
		var level_name = "Level" + str(i)
		
		# Zkontrolujeme, jestli level už existuje ve slovníku v LevelData
		if level_name in LevelData.level_dictionary:
			var data = LevelData.level_dictionary[level_name]
			
			# Hráč už level hrál (nebo je odemčený) - vypíšeme jeho statistiky
			add_label(level_name)
			add_label(str(data["coins"]))
			add_label(str(data["damage_taken"]))
			add_label(str(data["deaths"]))
			add_label(str(data["enemies_beaten"]))
			add_label(str(data["score"]))
			# Zaokrouhlíme čas na 2 desetinná místa, ať tam není nekonečné číslo
			add_label("%.2f" % float(data["timer"]) + " s") 
		else:
			# Hráč u tohoto levelu ještě nebyl, vypíšeme pomlčky
			add_label(level_name)
			for j in range(6): 
				add_label("-")

# --- MAGICKÁ FUNKCE ---
# Tohle je funkce, která "vyrobí" Label ze vzduchu, napíše do něj text a vloží ho do mřížky
func add_label(text_to_show: String):
	var lbl = Label.new()
	lbl.text = text_to_show
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	#přidáni fontu
	lbl.add_theme_font_override("font", my_font)
	lbl.add_theme_font_size_override("font_size", 23)
	# Pokud bychom chtěli, aby se sloupce samy roztáhly podle nejdelšího textu:
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL 
	
	grid.add_child(lbl)

# Tlačítko na zavření tabulky
func _on_close_button_pressed() -> void:
	self.visible = false
