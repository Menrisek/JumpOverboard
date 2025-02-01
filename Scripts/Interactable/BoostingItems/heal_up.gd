extends Node2D
class_name HealthUp

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		#zvýší mu to zdraví permanentně (když odstraním jen řádek pod tak ho imo healnu [na to muzu udelat dalsi item]
		area.get_parent().heal(1)
		queue_free()
