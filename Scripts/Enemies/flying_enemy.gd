extends CharacterBody2D
class_name FlyingEnemy

@onready var target = #tady musím vzít ten vyšší note a v něm hráče

var speed=150
func _physics_process(delta: float) -> void:
	var direction= (target.position-position).normalized()
	velocity = direction * speed
	look_at(target.position)
	move_and_slide()
