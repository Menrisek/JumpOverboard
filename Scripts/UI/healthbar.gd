extends Control
class_name HealthBar

#jak velký health bar je
@onready var fill_max = $ColorRect.size.x
var fill_amount : float

func update_healthbar(health, max_health):
	#musím health přehodit do floatu protože to jde na decimální číslo
	fill_amount = (float(health) / max_health * fill_max)
	$ColorRect.size.x = fill_amount
	# vysvětlení k výše uvedenému 2 / 3 = 0.66 * 24 = 18
