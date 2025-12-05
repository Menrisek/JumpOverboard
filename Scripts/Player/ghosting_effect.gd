extends Node2D

@export var fade_time := 0.25

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_time)
	tween.tween_callback(Callable(self, "queue_free"))
