extends Node2D

@export var moving_speed := 200.0
@export var dmg := 1
@export var rotation_speed := 10.0

@onready var left_point = $"Marker2D LeftPoint"
@onready var right_point = $"Marker2D RightPoint"
@onready var hitbox = $AttackArea

var target_position : Vector2

func _ready():
	target_position = right_point.global_position

func _process(delta):
	move_saw(delta)
	rotate_saw(delta)

func rotate_saw(delta):
	rotation += rotation_speed * delta

func move_saw(delta):
	global_position = global_position.move_toward(target_position, moving_speed * delta)
	
	# když dorazíme k bodu, přepneme směr
	if global_position.distance_to(target_position) < 5:
		if target_position == right_point.global_position:
			target_position = left_point.global_position
		else:
			target_position = right_point.global_position

func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(dmg)
