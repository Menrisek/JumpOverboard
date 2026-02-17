extends Node2D

@export var moving_speed := 200.0
@export var move_distance := 100.0   # jak daleko se má hýbat
@export var dmg := 1
@export var rotation_speed := 30.0

@onready var hitbox = $AttackArea

var start_position : Vector2
var direction := 1   # 1 = doprava, -1 = doleva

func _ready():
	start_position = global_position

func _process(delta):
	rotate_saw(delta)
	move_saw(delta)

func rotate_saw(delta):
	rotation += rotation_speed * delta

func move_saw(delta):
	global_position.x += moving_speed * direction * delta
	
	# kontrola vzdálenosti
	if abs(global_position.x - start_position.x) >= move_distance:
		direction *= -1

func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(dmg)
