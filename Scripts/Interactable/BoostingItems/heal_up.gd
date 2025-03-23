extends Node2D
class_name HealthUp

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		#healne to hráče
		area.get_parent().heal(1)
		queue_free()
