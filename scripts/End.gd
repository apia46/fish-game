extends ColorRect
class_name End

@onready var stats = %stats
@onready var game:Game = $"/root/game"

func _ready() -> void:
	for stat in 5:
		%stats.get_child(stat).text = game.stats[stat]
