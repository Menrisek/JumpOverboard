extends CharacterBody2D
class_name Player

@onready var animation= $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var attack_area = $AttackArea
@onready var coyote_timer = $CoyoteTimer
@onready var firing_point = $FiringPoint

#sound effekty
@onready var sfx_sword_swing = $"SFX Sword Swing"
@onready var sfx_get_hit = $"SFX Hit"
@onready var sfx_heal_taken = $"SFX Heal taken"
@onready var sfx_jump = $"SFX Jump"

@export var show_hp = true

@export var speed = 250.0
@export var jump_height = -300.0
@export var dash_power = 2.5
var has_dashed_in_air = false
var can_dash = true
var default_speed = speed
var default_jump_height = jump_height


var ghosting_effect_scene = preload("res://Scenes/Entities/ghosting_effect.tscn")
var ghosting = false

var knife_path=preload("res://Scenes/Entities/knife.tscn")
@onready var firing_offset_x = firing_point.position.x

var attacking = false
var hit = false

@export var max_health = 3
@onready var health = 0
var hearts_list : Array[TextureRect]
var can_take_damage = true

var time = GameManager.speedrun_time
var jump_buffering = 0.0

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
	if show_hp == false:
		$PlayerUI/HeartsContainer.hide()

func _process(delta):
	if Input.is_action_just_pressed("attack") && !hit:
		attack()
	time = float(time) + delta
	update_timer_ui()

func _physics_process(delta):
	#přehazuje strany postavy a attack arei
	if Input.is_action_just_pressed("left"):
		attack_area.scale.x = abs(attack_area.scale.x) * -1
		firing_point.position.x = -firing_offset_x
		sprite.flip_h = true
		
	if Input.is_action_just_pressed("right"):
		attack_area.scale.x = abs(attack_area.scale.x)
		firing_point.position.x = firing_offset_x
		sprite.flip_h = false

	# házení nožů
	if Input.is_action_just_pressed("throw"):
		throw()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump"):
		jump_buffering = 0.1
	jump_buffering -= delta
	
	# úprava intezity skoku
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.4
		
	# Handle jump.
	if jump_buffering > 0 and (is_on_floor() or !coyote_timer.is_stopped()):
		sfx_jump.play()
		jump_buffering = 0.0
		velocity.y = jump_height
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	var was_on_floor = is_on_floor()
	
	# dash
	# pokud je na zemi tak může dashnout (a neovlivňuje to has_dashed_in_air)
	# pokud je ve vzduchu tak může dashnout pouze pokud ještě v něm nedashnul
	if Input.is_action_just_pressed("dash"):
		handle_dash(direction)
	
	move_and_slide()
	
	if not was_on_floor and is_on_floor():
		has_dashed_in_air = false
		#tady můžu přidat nějakou přistávací animaci
		
	# pokud je a nebo není na podlaze zapne se timer
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
		
	update_animation()

	
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
	speed = default_speed
	jump_height = default_jump_height
	# resetuju
	can_dash = true
	has_dashed_in_air = false
	GameManager.respawn_player()
	update_heart_display()
	# ZDE KDYBYCH CHTĚL HEALTHBAR POD HRÁČEM: get_node("Healthbar").update_healthbar(health, max_health)

func attack():
	var overlapping_objects = attack_area.get_overlapping_areas()
	for area in overlapping_objects:
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().take_damage(1)
	
	attacking = true
	sfx_sword_swing.play()
	var random_attack = randi_range(1, 3)  # náhodně vybere mezi 1. nebo 2. nebo 3. útokem
	animation.play("attack" + str(random_attack))

func take_damage(damage_amouth : int):
	if can_take_damage:
		#zavolám první imunitu aby nemohl dostat znovu dmg
		immunityframes()
		
		hit = true
		attacking = false
		animation.play("hit")
		sfx_get_hit.play()
		
		
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
	sfx_heal_taken.play()
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

func update_timer_ui():
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
	if "level_title" in get_parent():
		$PlayerUI/LevelNumber.text = get_parent().level_title
	else:
		$PlayerUI/LevelNumber.text = "Tento level nemá title"

func _on_dash_timer_timeout() -> void:
	#reset speed to normal
	speed = default_speed
	
	ghosting = false
	$GhostingEffectTimer.stop()



func _on_dash_cooldown_timer_timeout() -> void:
		can_dash = true
		
func handle_dash(direction):
	ghosting = true
	spawn_ghost()
	$GhostingEffectTimer.start()
	
	if not can_dash:
		return

	if is_on_floor():
		can_dash = false
		$DashCooldownTimer.start() # zapne dash cooldown
		$DashTimer.start()
		speed *= dash_power
		velocity.x = direction * speed
		# když dashne na zemi, nechám možnost dashnout znovu i ve vzduchu (reset)
		has_dashed_in_air = false
	else:
		if not has_dashed_in_air:
			$DashTimer.start()
			speed *= dash_power
			velocity.x = direction * speed
			# označíme, že už dashoval ve vzduchu — další dash ve vzduchu nebude možný
			has_dashed_in_air = true

func throw():
	var knife = knife_path.instantiate()
	knife.owner_type = Knife.OwnerType.PLAYER

	# směr podle sprite.flip_h
	if sprite.flip_h:
		knife.direction = -1
		knife.scale.y = -1
	else:
		knife.direction = 1
		knife.scale.y = 1

	knife.global_position = firing_point.global_position
	
	# otočení sprite nože
	if knife.direction == 1:
		knife.rotation = 0.0
	else:
		knife.rotation = PI
	
	get_parent().add_child(knife)

#ghosting effect
func spawn_ghost():
	var ghost = ghosting_effect_scene.instantiate()
	var ghost_sprite = ghost.get_node("Sprite2D")
	
	#Zkopíruju texturu + flipnutí postavy
	ghost.global_position = global_position
	ghost_sprite.texture = sprite.texture
	ghost_sprite.hframes = sprite.hframes
	ghost_sprite.vframes = sprite.vframes
	ghost_sprite.frame = sprite.frame
	ghost_sprite.flip_h = sprite.flip_h

	get_parent().add_child(ghost)

func _on_GhostTimer_timeout():
	if ghosting:
		spawn_ghost()

func _on_ghosting_effect_timer_timeout() -> void:
	if ghosting:
		spawn_ghost()
