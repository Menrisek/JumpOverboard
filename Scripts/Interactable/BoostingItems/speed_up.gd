extends Node2D
class_name SpeedUp

@export var speed_change = 100
@export var speeding_time = 3.0

@onready var sfx_speed_up_taken = $"SFX SpeedUp taken"

var item_taken = false

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player and !item_taken:
		item_taken = true
		sfx_speed_up_taken.play()
		area.get_parent().speed += speed_change
		self.visible = false
		await get_tree().create_timer(speeding_time).timeout
		area.get_parent().speed -= speed_change
		respawn()

func respawn():
	item_taken = false
	self.visible = true
