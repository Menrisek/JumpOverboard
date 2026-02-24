extends Control

# Cesta kam se uloží konfigurace 
const SAVE_PATH = "user://Saves/settings.cfg"

@onready var master_slider = $PauseMenu/VBoxContainer/MasterSlider
@onready var music_slider = $PauseMenu/VBoxContainer/MusicSlider
@onready var sfx_slider = $PauseMenu/VBoxContainer/SFXSlider

var master_bus_idx: int
var music_bus_idx: int
var sfx_bus_idx: int

func _ready():
	# Získám ID našich sběrnic pro rychlejší přístup
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	
	load_settings()

# Pomocná funkce, která převede lineární hodnotu ze slideru na decibely
func set_bus_volume(bus_idx: int, linear_value: float):
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear_value))
	# Pokud je slider úplně na nule, sběrnici pro jistotu úplně ztlumím
	AudioServer.set_bus_mute(bus_idx, linear_value < 0.01)

# Uložení do souboru
func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master", master_slider.value)
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.save(SAVE_PATH)

# Načtení ze souboru
func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err == OK:
		# Načteme hodnoty
		# Poslední parametr (1.0) je defaultní hodnota, pokud něco selže
		master_slider.value = config.get_value("audio", "master", 1.0)
		music_slider.value = config.get_value("audio", "music", 1.0)
		sfx_slider.value = config.get_value("audio", "sfx", 1.0)
	else:
		# Pokud soubor neexistuje (hra se zapla poprvé), nastavím vše naplno
		master_slider.value = 1.0
		music_slider.value = 1.0
		sfx_slider.value = 1.0

	# Aplikuju hlasitost do systému
	set_bus_volume(master_bus_idx, master_slider.value)
	set_bus_volume(music_bus_idx, music_slider.value)
	set_bus_volume(sfx_bus_idx, sfx_slider.value)

# Signály ze sliderů
func _on_master_slider_value_changed(value):
	set_bus_volume(master_bus_idx, value)
	save_settings()

func _on_music_slider_value_changed(value):
	set_bus_volume(music_bus_idx, value)
	save_settings()

func _on_sfx_slider_value_changed(value):
	set_bus_volume(sfx_bus_idx, value)
	save_settings()


func _on_back_to_menu_button_pressed() -> void:
	self.visible = false

func _on_apply_button_pressed() -> void:
	print("Settings changes has been applied")
	save_settings()
