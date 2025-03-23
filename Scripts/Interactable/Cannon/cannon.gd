extends StaticBody2D
class_name Cannon

@onready var animation = $AnimationPlayer
@onready var firepoint = $Firepoint
var cannon_ball = load("res://Scenes/Interactable/Cannon/cannon_ball.tscn")
var debris = load("res://Scenes/Interactable/Cannon/cannon_debris.tscn")

@onready var sfx_canon_fire = $"SFX CanonFire"

@export var shooting : bool
#jak často bude střílet (v sekundách)
@export var fire_rate = 1.5
@export var distance = 300
@export var score = 0
@export var max_health = 3
var health = 0

func _ready():
	health = max_health
	shooting = true
	shoot()

func shoot():
	while shooting:
		animation.play("fire")
		await get_tree().create_timer(fire_rate).timeout

#je použita v animation playeru
func fire():
	#vytvoří dělovou kouli
	var spawned_ball = cannon_ball.instantiate()
	spawned_ball.set_distance(distance)
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.position
	#přidá se to do "stromu"
	add_child(spawned_ball)
	sfx_canon_fire.play()
	

func die():
	# kdybych chtěl abyse kanón počátal jako enemy, ale to bych to musel předělat ještě v RunTimeLevel
	# GameManager.enemies_beaten += 1
	GameManager.score += score
	#vytvoří trosky kanónu
	var spawned_debris = debris.instantiate()
	spawned_debris.global_position = position
	spawned_debris.scale.x = scale.x
	spawned_debris.get_child(1).play("crumble")
	#Tohle je shit -> protože budu ničit kanóny nemůžu to přidat jako child mého kanónu, tak to přidám jako child pro lvl.
	#včetně tohoto -> musí tam být 1, protože mám autoload script UI manager 
	get_tree().current_scene.add_child(spawned_debris)
	queue_free()

func take_damage(damage_amount):
	health -= damage_amount
	
	get_node("Healthbar").update_healthbar(health, max_health)
	
	animation.play("hit")
	if health <=0:
		die()
