extends CharacterBody2D
class_name Player

@onready var animation= $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var attack_area = $AttackArea

@export var speed = 300.0
@export var jump_height = -400.0
var attacking = false
var hit = false

@export var max_health = 2
@onready var health = 0
var hearts_list : Array[TextureRect]
var can_take_damage = true
var current_position_x = velocity.x

var time = GameManager.speedrun_time

func _ready():
	GameManager.damage_taken = 0
	health = max_health
	GameManager.player = self
	time = 0
	#kolik má srdcí tak tolik to zobrazí
	var hearts_parent = $PlayerUI/HeartsContainer
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	level_intro_text()

func _process(delta):
	if Input.is_action_just_pressed("attack") && !hit:
		attack()
	time = float(time) + delta
	update_ui()

func _physics_process(delta):
	if Input.is_action_just_pressed("left"):
		sprite.flip_h = true
		attack_area.scale.x = abs(attack_area.scale.x) * -1
	if Input.is_action_just_pressed("right"):
		sprite.flip_h = false
		attack_area.scale.x = abs(attack_area.scale.x)
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	update_animation()
	move_and_slide()
	
	if position.y >= 400:
		die()

#není potřeba protože nemůžu proskakovat platformami
func _input(event):
	if event.is_action_pressed("down") && is_on_floor():
		position.y +=1

func update_animation():
	if !attacking && !hit:
		#Animace běhu a idlu
		if velocity.x !=0:
			animation.play("run")
		else:
			animation.play("idle")

		#Animace skoku
		if velocity.y < 0:
			animation.play("jump")
		if velocity.y > 0:
			animation.play("fall")

func die():
	GameManager.deaths += 1
	GameManager.respawn_player()
	update_heart_display()
	# ZDE KDYBYCH CHTĚL HEALTHBAR POD HRÁČEM: get_node("Healthbar").update_healthbar(health, max_health)

func attack():
	var overlapping_objects = attack_area.get_overlapping_areas()
	
	for area in overlapping_objects:
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().take_damage(1)
	
	attacking = true
	animation.play("attack2")

func take_damage(damage_amouth : int):
	if can_take_damage:
		#zavolám první imunitu aby nemohl dostat znovu dmg
		immunityframes()
		
		hit = true
		attacking = false
		animation.play("hit")
		
		
		GameManager.damage_taken +=1
		
		health -= damage_amouth
		print("Current health: " + str(health))
		#není to dokonalé, ale jinak takto funguje health bar pod hráčem (+ ve funkci die() je stejný bar)
		# ZDE KDYBYCH CHTĚL HEALTHBAR POD HRÁČEM: get_node("Healthbar").update_healthbar(health, max_health)
		update_heart_display()
		
		if health <= 0:
			die()

#updatování srdíček
func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health

func heal(amount: int):
	if health < max_health:
		health += amount
		#zajistím aby zdraví nepřekročilo maximum
		health = min(health, max_health)
		#aktualizuju zobrazení srdcí
		update_heart_display()
		print("Healed! Current health: " + str(health))
	else:
		print("Health is already full!")

#hráč nemůže dostávat poškození
func immunityframes():
	can_take_damage = false
	#hráč bude mít imunitu na x sekundy
	await get_tree().create_timer(0.2).timeout
	can_take_damage = true

func update_ui():
	#formát s dvěmi decimálními čísly
	var formatted_time = str(time)
	var decimal_index = formatted_time.find(".")
	
	if decimal_index > 0:
		formatted_time = formatted_time.left(decimal_index + 3)  #vezme to jen 2 decimální místa
	
	GameManager.speedrun_time = formatted_time
	
	$PlayerUI/SpeedrunTimer.text = formatted_time
	
func level_intro_text():
	$PlayerUI/LevelNumber/AnimationPlayer.play("level_title_appear")
	#title je nadefinován v RunTimeLevelu
	$PlayerUI/LevelNumber.text = get_parent().level_title
