extends Node2D
class_name Knife

var direction := 1
@export var speed := 2000
@export var lifetime := 2.0

var hit := false

func _ready():
	await get_tree().create_timer(lifetime).timeout
	die()

func _physics_process(delta):
	if hit:
		return
		
	position.x += speed * delta * direction

func die():
	hit = true
	queue_free()

func _on_area_2d_area_entered(area):
	if hit:
		return

	var parent = area.get_parent()

	# enemy
	if parent.is_in_group("Enemies"):
		parent.take_damage(1)
		die()

func set_distance(distance: float):
	lifetime = distance/speed
