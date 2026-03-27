extends TextureRect
class_name Bar

@onready var player:Player = %player
@onready var fish:Fish = $"fish"

func start() -> void:
	player.active = true
	fish.active = true
	fish.start()

func stop() -> void:
	player.active = false
	fish.active = false
	fish.cancel_all_timers()
	fish.self_modulate.a = 1
