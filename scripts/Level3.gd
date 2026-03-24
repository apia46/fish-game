extends Level
class_name Level3

func start() -> void:
	%bar.start()

func _process(_delta) -> void:
	if %bar.fish.phase > 0:
		%camera.position.y = %player.position.y

func win() -> void:
	pass
