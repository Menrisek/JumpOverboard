extends Node2D
class_name HealUp

var start_position: Vector2

func _ready():
	start_position = position
	$AnimationPlayer.play("float")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		#healne to hráče
		area.get_parent().heal(1)
		queue_free()
