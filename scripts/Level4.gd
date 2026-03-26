extends Level
class_name Level4

func start() -> void:
	%bar.start()

func win() -> void:
	pass

func _process(_delta) -> void:
	%camera.position = %player.position
	%stars.position = %camera.get_screen_center_position() * 0.2
	%stars_bg.position = %camera.get_screen_center_position() * 0.1
