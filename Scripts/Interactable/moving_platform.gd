extends Node2D
class_name MovingPlatform

@onready var animation = $AnimatableBody2D/AnimationPlayer

@export var timer = 0.0
@export var moving_up = false

func _ready():
	#zde je v animaci i ten pohyb
	if moving_up == true:
		await get_tree().create_timer(timer).timeout
		animation.play("move_up")
	else:
		await get_tree().create_timer(timer).timeout
		animation.play("move")
