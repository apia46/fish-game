extends Level
class_name Level4

func start() -> void:
	%bar.start()
	await get_tree().create_timer(1).timeout
	summon_black_hole()

func win() -> void:
	pass

func _process(_delta) -> void:
	%camera.position = %player.position
	%stars.position = %camera.get_screen_center_position() * 0.2
	%stars_bg.position = %camera.get_screen_center_position() * 0.1

func summon_black_hole() -> void:
	var black_hole = BlackHole.new()
	%world.add_child(black_hole)
	black_hole.position = %bar.fish.position
	%bar.player.black_holes.append(black_hole)
