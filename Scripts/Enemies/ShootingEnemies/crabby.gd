extends CharacterBody2D 
class_name ShootingEnemy


@export_category("Health")
@export var max_health := 20
@export var can_die := true
@export var can_respawn := false
@export var respawn_time := 2.0

@export_category("DPS")
@export var enable_dps := true
@export var dps_reset_time := 1.5

@export_category("Hit Numbers")
@export var enable_hit_numbers := true

@export_category("Movement")
@export var enable_movement := true
@export var move_speed := 40.0
@export var move_distance := 100.0

@export_category("Attack")
@export var can_attack := true
@export var damage_to_player := 1
@export var attack_cooldown := 1.0

@export_category("Knife Attack")
var knife_path=preload("res://Scenes/Entities/knife.tscn")


@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox
@onready var damage_label: Label = $DamageLabel
@onready var dps_label: Label = $DPSLabel
@onready var respawn_timer: Timer = $RespawnTimer
@onready var hit_number_spawner: Node2D = $HitNumberSpawner
@onready var firing_point = $FiringPoint
@onready var firing_offset_x = firing_point.position.x
@onready var attack_area = $DetectionArea


var health := 0
var total_damage := 0
var dps_timer := 0.0
var spawn_position := Vector2.ZERO
var move_direction := 1
var can_damage_player := true



func _ready():
	add_to_group("Enemies")
	anim.play("run")
	health = max_health
	spawn_position = global_position
	
	if not enable_dps:
		dps_label.hide()
	if not enable_hit_numbers:
		damage_label.hide()
	
	respawn_timer.timeout.connect(respawn)
	hitbox.body_entered.connect(_on_hitbox_area_entered)

#damage per sec a zapnutí pohybu
func _process(delta):
	if enable_dps:
		dps_timer += delta
		
		if dps_timer > dps_reset_time:
			total_damage = 0
		
		var dps : float = total_damage / max(dps_timer, 0.01)
		dps_label.text = "DPS: %.1f" % dps
	
	if enable_movement:
		patrol(delta)

#dostávání dmg 
func take_damage(amount: int):
	if health <= 0:
		return
	
	health -= amount
	total_damage += amount
	dps_timer = 0.0
	
	
	show_hit(amount)
	flash()
	update_labels()
	update_healthbar()
	
	if health <= 0 and can_die:
		die()

#smrt a respawn
func die():
	sprite.hide()
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	can_attack = false
	enable_movement = false

	if can_respawn:
		respawn_timer.start(respawn_time)
		await get_tree().create_timer(respawn_time).timeout
		enable_movement = true
	else:
		queue_free()

func respawn():
	health = max_health
	total_damage = 0
	dps_timer = 0.0
	sprite.show()
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable",true)
	update_labels()
	update_healthbar()


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		velocity.y = 0

	if enable_movement:
		patrol(delta)


#pohyb
func patrol(_delta):
	velocity.x = move_direction * move_speed
	move_and_slide()
	
	if abs(global_position.x - spawn_position.x) > move_distance:
		move_direction *= -1
		sprite.flip_h = move_direction < 0

	if sprite.flip_h:
		firing_point.position.x = -abs(firing_offset_x)
		attack_area.scale.x = -abs(attack_area.scale.x)
	else:
		firing_point.position.x = abs(firing_offset_x)
		attack_area.scale.x = abs(attack_area.scale.x)



#updatování healthbaru
func update_healthbar():
	get_node("Healthbar").update_healthbar(health, max_health)


#ukazování kolik mu zbývá hp
func show_hit(amount: int):
	if not enable_hit_numbers:
		return
	
	damage_label.text = "-" + str(amount)
	damage_label.modulate = Color(1, 0.2, 0.2)
	damage_label.show()
	
	damage_label.scale = Vector2.ONE * 1.2
	await get_tree().create_timer(0.3).timeout
	damage_label.hide()


#testování dummyho (zakomentovat později)
func flash():
	anim.play("hit")
	sprite.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.08).timeout
	sprite.modulate = Color(1, 1, 1)

func update_labels():
	if damage_label:
		damage_label.text = "HP: " + str(health)


#nože
func _on_hitbox_area_entered(area):
	if not can_attack:
		return
	
	if not can_damage_player:
		return
	
	if health <= 0:
		return
	
	var player = area.get_parent()
	if player is Player:
		player.take_damage(damage_to_player)
		start_attack_cooldown()


func start_attack_cooldown():
	can_damage_player = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_damage_player = true

func throw():
	var knife = knife_path.instantiate()
	knife.owner_type = Knife.OwnerType.ENEMY

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


func _on_detection_area_area_entered(area):
	var body = area.get_parent()

	if not body.is_in_group("Player"):
		return

	call_deferred("throw") # musím zpozdit vytvoření nože o jeden frame, aby godot neměl problém
