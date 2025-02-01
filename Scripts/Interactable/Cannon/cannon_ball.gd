extends Node2D
class_name CannonBall

@onready var animation= $AnimationPlayer

var direction
@export var speed = 200.00
@export var lifetime = 2.0
var hit = false

func _ready():
	await get_tree().create_timer(lifetime).timeout
	die()

#pohyb koule
func _physics_process(delta):
	position.x +=abs(speed * delta) * direction

func die():
	hit = true
	speed = 0
	#queue_free je zase v animaci TOHLE JE TED ZBYTEČNÉ, PROTOŽE MI TO NEDÁ HIT
	animation.play("hit")
	

func _on_area_2d_area_entered(area):
	# když připíšu && !hit tak potom, co dostane hit přestane střílet
	if area.get_parent() is Player:
		#dá vždycky instakill, ale s queue_free mi to nefunguje
		area.get_parent().die() #take_damage(100)
		die()
	elif area.get_parent() is not Cannon:
		die()

#vypočítám životnost koule přes rychlost a dálku, a když změním dálku tak se mi životnost zvětší takže jako fyzika yk
func set_distance(distance: int):
	lifetime = distance/speed
