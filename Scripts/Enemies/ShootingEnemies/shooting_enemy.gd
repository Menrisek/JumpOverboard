extends CharacterBody2D
class_name EnemyShooter

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var fire_point = $FirePoint
@onready var detection_area = $DetectionArea

@export var bullet_scene: PackedScene
@export var max_health := 3
@export var fire_rate := 1.2
@export var shoot_range := 500
@export var move_speed := 40
@export var can_move := false  # když chceš, aby chodil

var health := 0
var can_shoot := true
var dead := false
var player: Player = null

func _ready():
	health = max_health
	detection_area.area_entered.connect(_on_area_entered)
	detection_area.area_exited.connect(_on_area_exited)

func _physics_process(delta):
	if dead: return

	if player:
		_face_player()
		if can_move:
			_move_to_player(delta)
		if can_shoot:
			_start_shooting()
	else:
		velocity.x = 0
		move_and_slide()

# -------------------------------------------------------------
# ZÁKLADNÍ FUNKCE
# -------------------------------------------------------------

func _face_player():
	if player.global_position.x > global_position.x:
		sprite.scale.x = abs(sprite.scale.x)
	else:
		sprite.scale.x = -abs(sprite.scale.x)

func _move_to_player(_delta):
	var dir = sign(player.global_position.x - global_position.x)
	velocity.x = dir * move_speed
	move_and_slide()

func _start_shooting():
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

# Zavolá animace "shoot"
func fire():
	if dead: return
	var b = bullet_scene.instantiate()
	b.global_position = fire_point.global_position
	b.direction = sign(sprite.scale.x)
	get_tree().current_scene.add_child(b)

# -------------------------------------------------------------
# DETEKCE HRÁČE
# -------------------------------------------------------------

func _on_area_entered(area):
	var p = area.get_parent()
	if p is Player:
		player = p
		fire()

func _on_area_exited(area):
	if area.get_parent() == player:
		player = null

# -------------------------------------------------------------
# ZDRAVÍ, HIT, SMRT
# -------------------------------------------------------------

func take_damage(amount):
	if dead: return
	health -= amount

	if health <= 0:
		die()

func die():
	dead = true
	velocity = Vector2.ZERO
