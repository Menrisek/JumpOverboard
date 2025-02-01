extends Node2D
class_name FallingSpikes

@onready var animation= $AnimationPlayer
@onready var spawn_pos = global_position

@export var speed = 300.0
@export var time_to_live = 2.5
#(-1,0)= levo, (1,0) = pravo, (0,-1) = nahoru, můžu i diagonálně (1,1),(-1,1)// kdyžtak se zeptat lukáše atd.
@export var direction: Vector2 = Vector2(0, 1)

var current_speed = 0.0

func _physics_process(delta):
	#pohyb ve směru vektoru znormalizovaný, takže když diagonálně se nebude hýbat rychleji
	position += direction.normalized() * current_speed * delta

func _on_hitbox_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().die()


func _on_player_detection_zone_area_entered(area):
	if area.get_parent() is Player:
		animation.play("Shake")

#je použita v animation playeru
func fall():
	current_speed = speed
	#po x sekundách se vymažou a zároveň obnoví
	await get_tree().create_timer(time_to_live).timeout
	position = spawn_pos
	current_speed = 0
