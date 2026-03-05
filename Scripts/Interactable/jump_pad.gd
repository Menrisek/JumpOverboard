extends Node2D
class_name JumpPad

@export var force = -500.0

func _ready():
	$AnimationPlayer.play("spinn")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		var player = area.get_parent()
		player.velocity.y = force
		
		# Refresh schopností
		# Hráč dostane zpět dash ve vzduchu
		player.has_dashed_in_air = false 
		
		# pokud má max_jumps = 1 tak už neskočí, ale pokud má double jump, tedy max_jumps = 2,
		# tak mmůže ve vzduchu po vyletění z tornáda ještě jednou skočit (protože mu zbývá ještě jeden skok)
		player.current_jumps = 1
