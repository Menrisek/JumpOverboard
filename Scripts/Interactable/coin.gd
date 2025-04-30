extends Node2D
class_name Coin

@export var coins = 1
var score = coins * 10

@onready var sfx_coin_taken = $"SFX Coin Taken"

func _ready():
	$AnimationPlayer.play("idle")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		#vypíná kolizi
		$Area2D.set_deferred("monitoring", false)
		GameManager.gain_coins(coins)
		sfx_coin_taken.play()
		GameManager.score += score
		$AnimationPlayer.play("coin_taken")
		#KDYBYCH CHTĚL ABY COIN ZMIZEL PO DOKONČENÍ ANIMACE
		#await $AnimationPlayer.animation_finished
		#queue_free()
