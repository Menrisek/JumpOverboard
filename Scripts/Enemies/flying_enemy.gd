extends CharacterBody2D
class_name FlyingEnemy

@export var max_health = 2
@export var score = 150
@export var flying_speed = 150

var default_flying_speed = flying_speed
var health = 0
var hit = false
var can_attack = true
var can_take_damage = true
var dead = false
var knockback = 120

@onready var target = get_parent().get_node("Player")

func _ready():
	health = max_health

func _physics_process(_delta: float) -> void:
	var direction = (target.position-position).normalized()
	velocity = direction * flying_speed
	look_at(target.position)
	move_and_slide()

func take_damage(damage_amount):
	if !dead:
		#na 0.2 sekundy bude nesmrtelný (imunity frames)
		if can_take_damage:
			immunityframes()
			#kdyby něco tak animaci po hitu dát sem
			health -= damage_amount
		
		get_node("Healthbar").update_healthbar(health, max_health)
		
		if health <=0:
			die()
			
func immunityframes():
	can_take_damage = false
	#enemy bude mít imunitu na x sekundy
	await get_tree().create_timer(0.2).timeout
	can_take_damage = true

func die():
	GameManager.score += score
	GameManager.enemies_beaten += 1
	dead = true
	flying_speed = 0
	queue_free()
	
#utok do hráče
func _on_attack_area_area_entered(area):
	if area.get_parent() is Player && !dead && can_attack:
		area.get_parent().take_damage(1)
		#knockback zpátky
		flying_speed = -knockback
		await get_tree().create_timer(0.35).timeout
		flying_speed = default_flying_speed
	
