extends Node2D

# definuje dvě možnosti, ze kterých si budu vybírat
enum Axis { HORIZONTAL, VERTICAL }

# rozbalovací menu pro inspektor
@export var move_axis: Axis = Axis.HORIZONTAL

@export var moving_speed := 200.0
@export var move_distance := 100.0   # jak daleko se má hýbat
@export var dmg := 1
@export var rotation_speed := 30.0

@onready var hitbox = $AttackArea

var start_position : Vector2
var direction := 1   # 1 = doprava/dolů, -1 = doleva/nahoru

func _ready():
	start_position = global_position

func _process(delta):
	rotate_saw(delta)
	move_saw(delta)

func rotate_saw(delta):
	rotation += rotation_speed * delta

func move_saw(delta):
	# Zkontroluju, co je nastaveno v inspektoru
	if move_axis == Axis.HORIZONTAL:
		#Horizontální pohyb (po ose X)
		global_position.x += moving_speed * direction * delta
		
		# kontrola vzdálenosti pro osu X
		if abs(global_position.x - start_position.x) >= move_distance:
			direction *= -1
			
	elif move_axis == Axis.VERTICAL:
		# Vertikální pohyb (po ose Y)
		global_position.y += moving_speed * direction * delta
		
		# kontrola vzdálenosti pro osu Y
		if abs(global_position.y - start_position.y) >= move_distance:
			direction *= -1

func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().take_damage(dmg)
