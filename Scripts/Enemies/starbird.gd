extends CharacterBody2D
class_name FlyingEnemy

@export var max_health = 2
@export var score = 150
@export var flying_speed = 150
@export var damage_to_player := 1

@export_category("Patrol settings")
@export var enable_patrol = false        # jestli má patrolovat
@export var patrol_point_a: Node2D        # první patrol point
@export var patrol_point_b: Node2D        # druhý patrol point
@export var chase_delay = 1            # jak dlouho ještě honí po ztrátě hráče

var default_flying_speed
var health = 0
var can_attack = true
var can_take_damage = true
var dead = false
var knockback = 120

var chasing = false              # hráč je v detekční zóně
var chase_timer_running = false  # časovač pro doběh honění
var returning = false            # vrací se na start
var patrolling = false           # právě patroluje

var start_position               # místo kde se objevil
var patrol_target                # aktuální cíl patrolování

@onready var target = get_parent().get_node("Player")
@onready var anim= $AnimationPlayer


func _ready():
	anim.play("run")
	health = max_health
	default_flying_speed = flying_speed
	start_position = position
	
	if enable_patrol:
		patrolling = true
		patrol_target = patrol_point_a


func _physics_process(delta):
	if dead:
		return

	#CHASE PLAYER
	if chasing:
		_chase_player()
		return
		
	#CHASE DELAY AFTER LOSING PLAYER
	elif chase_timer_running:
		_chase_player()
		return

	#PATROLLING
	elif patrolling:
		_patrol(delta)
		return

	#RETURN TO ORIGIN WHEN NOT PATROLLING
	else:
		_return_to_origin(delta)


#CHASING
func _chase_player():
	var dir = (target.position - position).normalized()
	velocity = dir * flying_speed
	look_at(target.position)
	move_and_slide()


#PATROLLING
func _patrol(_delta):
	if patrol_target == null:
		return
	
	var dir = (patrol_target.position - position)
	
	if dir.length() < 10:
		#Přepínání cílů
		patrol_target = patrol_point_b if patrol_target == patrol_point_a else patrol_point_a
	
	velocity = dir.normalized() * (flying_speed * 0.6)
	move_and_slide()



#RETURN TO START POSITION
func _return_to_origin(_delta):
	var dir = (start_position - position)
	if dir.length() < 5:
		velocity = Vector2.ZERO
		return
	
	velocity = dir.normalized() * (flying_speed * 0.6)
	move_and_slide()


#DAMAGE SYSTEM
func take_damage(damage_amount):
	if !dead and can_take_damage:
		immunityframes()
		health -= damage_amount
	
	get_node("Healthbar").update_healthbar(health, max_health)

	if health <= 0:
		die()


func immunityframes():
	can_take_damage = false
	await get_tree().create_timer(0.2).timeout
	can_take_damage = true


func die():
	GameManager.score += score
	GameManager.enemies_beaten += 1
	dead = true
	flying_speed = 0
	queue_free()



#ATTACK
func _on_attack_area_area_entered(area):
	if area.get_parent() is Player and can_attack and !dead:
		area.get_parent().take_damage(damage_to_player)

		flying_speed = -knockback
		await get_tree().create_timer(0.35).timeout
		flying_speed = default_flying_speed


#DETECTION ZONE
func _on_chasing_area_area_entered(area):
	if area.get_parent() is Player:
		chasing = true
		chase_timer_running = false

func _on_chasing_area_area_exited(area):
	if area.get_parent() is Player:
		chasing = false
		_start_chase_delay()

func _start_chase_delay():
	chase_timer_running = true
	await get_tree().create_timer(chase_delay).timeout
	chase_timer_running = false
