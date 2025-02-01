extends Node2D
class_name MovingPlatform

@onready var animation = $AnimatableBody2D/AnimationPlayer

@export var timer = 0.0

func _ready():
	#zde je v animaci i ten pohyb
	await get_tree().create_timer(timer).timeout
	animation.play("move")
