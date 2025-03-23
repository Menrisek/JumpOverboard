extends Node2D
class_name Checkpoint

@export var spawnpoint = false
@export var win_condition = false

@onready var sfx_checkpoin_taken = $"SFX Checkpoint taken"

var activated = false

func _ready():
	if spawnpoint:
		activate()

func activate():
	if win_condition:
		GameManager.win()
		
	GameManager.current_checkpoint = self
	activated = true
	$AnimationPlayer.play("activated")
	sfx_checkpoin_taken.play()

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !activated:
		activate()
