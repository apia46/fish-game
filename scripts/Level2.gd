extends Level
class_name Level2

@onready var swipe:Sprite2D = %swipe

func start() -> void:
	%bar.start()

func win() -> void:
	game.win_text.visible = true
	%bar.stop()

	await get_tree().create_timer(0.5).timeout
	game.win_text.visible = false
	game.start_level(preload("res://scenes/level_2.tscn"))
