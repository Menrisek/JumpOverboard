extends Node2D
class_name JumpPad

@export var force = -500.0

func _ready():
	$AnimationPlayer.play("spinn")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().velocity.y = force
