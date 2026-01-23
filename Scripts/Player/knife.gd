extends Node2D
class_name Knife

enum OwnerType { PLAYER, ENEMY }

@export var speed := 2000
@export var lifetime := 2.0

var direction := 1
var hit := false
var owner_type : OwnerType

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
	
	match owner_type:
		OwnerType.PLAYER:
			if parent.is_in_group("Enemies"):
				parent.take_damage(1)
				die()
		
		OwnerType.ENEMY:
			if parent is Player:
				parent.take_damage(1)
				die()

func _on_area_2d_body_entered(body: Node2D):
	if hit:
		return
	
	# kolize se světem → nůž se zničí
	if not body.is_in_group("Enemies") and not body is Player:
		die()


func set_distance(distance: float):
	lifetime = distance / speed
