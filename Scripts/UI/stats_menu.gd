extends Control
class_name StatsMenu

@onready var grid = $PauseMenu/GridContainer # Cesta GridContaineru

# Názvy 7 sloupců
var headers = ["Level Name", "Coins", "Hits Taken", "Deaths", "Enemies Beaten", "Score", "Time"]
var my_font = preload("res://Art/Fonts/PirateFont.ttf") # Sem dej svoji cestu

func _ready():
	# Opět použijeme náš trik: tabulka se updatne pokaždé, když ji ukážeš
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if visible:
		update_table()

func update_table():
	# Vyčistím starou tabulku (kdyby ji hráč otevřel podruhé)
	for child in grid.get_children():
		child.queue_free()
		
	# Vytvořím hlavičku neboli (nadpisy)
	for text in headers:
		add_label(text)
		
	# získám data pro Level 1 až 10 (range je vlastně od prvního lvlu až po 10, pokud jich budu mít více, tak musím zvětšit range)
	for i in range(1, 11):
		var level_name = "Level" + str(i)
		
		# Zkontroluju, jestli level už existuje ve slovníku v LevelData
		if level_name in LevelData.level_dictionary:
			var data = LevelData.level_dictionary[level_name]
			
			# Hráč už level hrál (nebo je odemčený) - vypíšešu jeho statistiky
			add_label(level_name)
			add_label(str(data["coins"]))
			add_label(str(data["damage_taken"]))
			add_label(str(data["deaths"]))
			add_label(str(data["enemies_beaten"]))
			add_label(str(data["score"]))
			# Zaokrouhlím čas na 2 desetinná místa
			add_label("%.2f" % float(data["timer"]) + " s") 
		else:
			# pokud hráč u tohoto levelu ještě nebyl, vypíšu pomlčky
			add_label(level_name)
			for j in range(6): 
				add_label("-")

# funkce pro generaci labelu, napíše do něj text a vloží ho do mřížky
func add_label(text_to_show: String):
	var lbl = Label.new()
	lbl.text = text_to_show
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# přidáni fontu a úprava jeho velikosti
	lbl.add_theme_font_override("font", my_font)
	lbl.add_theme_font_size_override("font_size", 23)
	# Pokud bych chtěl, aby se sloupce samy roztáhly podle nejdelšího textu
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL 
	
	grid.add_child(lbl)


func _on_close_button_pressed() -> void:
	self.visible = false
