extends Node2D
class_name Coin

@export var score = 10
@export var coins = 1

func _ready():
	$AnimationPlayer.play("idle")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		#vypíná kolizi
		$Area2D.set_deferred("monitoring", false)
		GameManager.gain_coins(coins)
		GameManager.score += score
		$AnimationPlayer.play("coin_taken")
		#po animaci se přehraje
		await $AnimationPlayer.animation_finished
		queue_free()
