extends Node2D
class_name EnemyBullet

@export var speed := 250.0
@export var lifetime := 2.0
var direction := 1
var hit := false

func _ready():
	await get_tree().create_timer(lifetime).timeout
	die()

func _physics_process(delta):
	if hit: return
	position.x += speed * delta * direction

func die():
	hit = true
	speed = 0

func _on_area_2d_area_entered(area):
	if hit: return

	var parent = area.get_parent()

	if parent.has_method("take_damage"):
		parent.take_damage(1)
		die()
	else:
		die()
