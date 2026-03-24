extends Level
class_name Level3

func start() -> void:
	%bar.start()

func _process(_delta) -> void:
	if %bar.fish.phase > 0:
		%camera.position.y = %player.position.y

func win() -> void:
	pass

func get_gravity() -> float: return lerp(50, 100, %player.position.y/%bar.size.y)

func get_dash_loss() -> float: return lerp(0.4, 0.8, (%player.position.y+648)/%bar.size.y)
