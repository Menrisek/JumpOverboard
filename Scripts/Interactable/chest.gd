extends Node2D
class_name Chest

var health = 1
#kdyby něco nefungovalo bylo tady @export var score = 100 (10 krát počet coinů)
@export var coins = 10
var score = coins * 10

func die_with_coins():
	queue_free()
	GameManager.score += score
	GameManager.gain_coins(coins)

func take_damage(damage_amount):
	health -= damage_amount
	if health <=0:
		die_with_coins()

func _on_hitbox_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)
