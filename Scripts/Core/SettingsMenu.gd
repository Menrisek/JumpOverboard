extends Control
class_name SettingsMenu

# Cesta kam se uloží konfigurace 
const SAVE_PATH = "user://Saves/settings.cfg"

# audio
@onready var master_slider = $PauseMenu/VBoxContainer/MasterSlider
@onready var music_slider = $PauseMenu/VBoxContainer/MusicSlider
@onready var sfx_slider = $PauseMenu/VBoxContainer/SFXSlider

# video
@onready var window_mode_options = $PauseMenu/VBoxContainer/WindowModeOptionButton
@onready var resolution_options = $PauseMenu/VBoxContainer/ResolutionOptionButton

var master_bus_idx: int
var music_bus_idx: int
var sfx_bus_idx: int

# výběr režimu okna
var window_modes: Array[String] = [
	"Windowed",
	"Borderless Windowed",
	"Fullscreen"
]

# výběr rozlišení (Vector2i protože to jsou jako celé pixely)
var resolutions: Array[Vector2i] = [
	Vector2i(2560, 1440), # 2K / QHD (Větší monitory)
	Vector2i(1920, 1080), # 1080p / Full HD (Standard)
	Vector2i(1600, 900),  # 900p / HD+
	Vector2i(1366, 768),  # Klasický rozměr většiny notebooků
	Vector2i(1280, 720),  # 720p / HD
	Vector2i(960, 540)    # Původní menší okno
]

func _ready():
	# Získám ID našich sběrnic pro rychlejší přístup
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	
	# Naplnění OptionButtonů
	for mode in window_modes:
		window_mode_options.add_item(mode)
		
	for res in resolutions:
		resolution_options.add_item(str(res.x) + "x" + str(res.y))
	
	load_settings()

# Pomocná funkce, která převede lineární hodnotu ze slideru na decibely
func set_bus_volume(bus_idx: int, linear_value: float):
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear_value))
	AudioServer.set_bus_mute(bus_idx, linear_value < 0.01)

# Režim okna
func apply_window_mode(index: int):
	match index:
		0: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			# Pokud se přepneme zpět do okna, aplikujeme rovnou i rozlišení, ať se vycentruje
			apply_resolution(resolution_options.selected)
		1: # Borderless Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: # Exclusive Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

# Rozlišení
func apply_resolution(index: int):
	var target_res = resolutions[index]
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	DisplayServer.window_set_size(target_res)
	
	# Vycentrování okna na obrazovce (pouze pro Windowed, neboli index 0)
	if window_mode_options.selected == 0:
		#zjistím na jakém monitoru se okno nachází
		var current_screen = DisplayServer.window_get_current_screen()
		
		#zjistím velikost a souřadnice toho konkrétního monitoru
		var screen_size = DisplayServer.screen_get_size(current_screen)
		var screen_pos = DisplayServer.screen_get_position(current_screen)
		
		@warning_ignore("integer_division") #ignoruju to, že se mi ztratí desetinné čísla z toho dělení níže, ale pixel nemá desetiny
		DisplayServer.window_set_position(screen_pos + (screen_size / 2 - target_res / 2))

# Uložení do souboru
func save_settings():
	var config = ConfigFile.new()
	# Uložení audia do kategorie audio
	config.set_value("audio", "master", master_slider.value)
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	
	# Uložení videa do kategorie video
	config.set_value("video", "window_mode_index", window_mode_options.selected)
	config.set_value("video", "resolution_index", resolution_options.selected)
	
	config.save(SAVE_PATH)

# Načtení ze souboru
func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err == OK:
		# audio - Nepouštím signály
		master_slider.set_value_no_signal(config.get_value("audio", "master", 1.0))
		music_slider.set_value_no_signal(config.get_value("audio", "music", 1.0))
		sfx_slider.set_value_no_signal(config.get_value("audio", "sfx", 1.0))
		
		# video
		window_mode_options.selected = config.get_value("video", "window_mode_index", 0)
		resolution_options.selected = config.get_value("video", "resolution_index", 1)
	else:
		# Defaultní hodnoty
		master_slider.set_value_no_signal(1.0)
		music_slider.set_value_no_signal(1.0)
		sfx_slider.set_value_no_signal(1.0)
		window_mode_options.selected = 0
		resolution_options.selected = 1

	# Aplikuju načtené hodnoty
	set_bus_volume(master_bus_idx, master_slider.value)
	set_bus_volume(music_bus_idx, music_slider.value)
	set_bus_volume(sfx_bus_idx, sfx_slider.value)
	
	apply_window_mode(window_mode_options.selected)
	apply_resolution(resolution_options.selected)

# signály
func _on_master_slider_value_changed(value):
	set_bus_volume(master_bus_idx, value)
	save_settings()

func _on_music_slider_value_changed(value):
	set_bus_volume(music_bus_idx, value)
	save_settings()

func _on_sfx_slider_value_changed(value):
	set_bus_volume(sfx_bus_idx, value)
	save_settings()

func _on_window_mode_option_button_item_selected(index: int) -> void:
	apply_window_mode(index)
	save_settings()

func _on_resolution_option_button_item_selected(index: int) -> void:
	apply_resolution(index)
	save_settings()

func _on_back_to_menu_button_pressed() -> void:
	self.visible = false
