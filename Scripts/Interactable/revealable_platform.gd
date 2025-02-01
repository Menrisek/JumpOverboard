extends StaticBody2D
class_name RevealablePlatform

@onready var animation = $AnimationPlayer

var showing = false

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player and !showing:
		showing = true
		animation.play("FadeIn") 

func _on_area_2d_area_exited(area):
	if area.get_parent() is Player and showing:
		showing = false
		animation.play("FadeOut")
