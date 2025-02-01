extends HBoxContainer
class_name HeartBar

@onready var heart_gui_class = preload("res://Scenes/UI/HeartsGUI/heart_gui.tscn")

func set_max_hearts(max_health : int):
	for i in range(max_health):
		var health = heart_gui_class.instantiate()
		add_child(health)
