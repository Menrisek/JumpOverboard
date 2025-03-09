extends CharacterBody2D
class_name Sharkie

@onready var animation= $AnimationPlayer
@onready var sprite = $Sprite2D

var speed = -60.0
var current_speed = 0.0
var facing_right = false
var dead = false
@export var max_health = 2
@export var score = 100
var health = 0
var hit = false
var can_attack = true
var can_take_damage = true

func _ready():
	health = max_health
	animation.play("run")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	
	velocity.x = speed
	move_and_slide()

#pokud je na konci platformy otočí se
func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func take_damage(damage_amount):
	if can_take_damage:
		immunityframes()
		
	if !dead:
		animation.play("hit")
		health -= damage_amount
		
		get_node("Healthbar").update_healthbar(health, max_health)
		
		if health <=0:
			die()

func get_hit():
	hit = !hit
	if hit:
		current_speed = speed
		speed = 0
		can_attack = false
	else:
		speed = current_speed
		can_attack = true
		animation.play("run")

func immunityframes():
	can_take_damage = false
	#hráč bude mít imunitu na x sekundy
	await get_tree().create_timer(0.1).timeout
	can_take_damage = true

func die():
	GameManager.score += score
	GameManager.enemies_beaten += 1
	dead = true
	speed = 0
	#v animaci je zavolání funkce "queue_free()"
	animation.play("die")

#utok do hráče
func _on_hitbox_area_entered(area):
	if area.get_parent() is Player && !dead && can_attack:
		area.get_parent().take_damage(1)
