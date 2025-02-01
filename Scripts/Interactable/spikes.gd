extends Node2D
class_name Spikes


@export var flip = false

func _ready():
	spikes_flipped()

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().die()

func spikes_flipped():
	if flip == true:
		$Sprite2D.flip_h = true
