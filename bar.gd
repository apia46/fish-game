extends Panel
class_name Bar

@onready var player:Player = %player
@onready var fish:Fish = %fish

func start() -> void:
    player.active = true
    fish.active = true
    fish.start()
