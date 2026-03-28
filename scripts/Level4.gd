extends Level
class_name Level4

func start() -> void:
	if !game.skip_tutorials:
		await GamePopup.create(self, "In space, you accelerate and dash towards your mouse position.", "Okay").closed
		await GamePopup.create(self, "Reminder: You can dash repeatedly to gain extra progress.", "Okay").closed
		await GamePopup.create(self, "Avoid bumping into things.", "What things?").closed
	%bar.start()

func win() -> void:
	game.stats.append(%bar.fish.get_stats())
	%bar.stop()

	await get_tree().create_timer(0.5).timeout

	var center:Vector2 = Vector2(576, 324)

	var tada:Tada = Game.new_tada("You caught the sun. Good job.")
	%end.add_child(tada)
	tada.position = center
	tada.scale = Vector2.ONE * 1.5
	var fish = %bar.fish
	var fish_pos:Vector2 = fish.position - %camera.get_screen_center_position() + center - Vector2.ONE*500
	%bar.remove_child(fish)
	%end.add_child(fish)
	fish.position = fish_pos
	fish.z_index = 2

	var win_tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	win_tween.parallel().tween_property(fish, ^"position", center, 0.8)
	win_tween.parallel().tween_property(fish, ^"rotation", TAU*2, 0.8)
	win_tween.parallel().tween_property(fish, ^"scale", Vector2.ONE*6, 0.5)
	win_tween.parallel().tween_property(tada.sprite, ^"scale", Vector2.ONE*4, 0.8)
	win_tween.parallel().tween_property(tada.sprite, ^"rotation", TAU, 0.8)
	win_tween.parallel().tween_property(tada.text, ^"start_offset", 100, 0.8)
	win_tween.parallel().tween_property(tada.text, ^"text_cutoff", 19, 0.8)
	win_tween.tween_interval(0.6)
	win_tween.parallel().tween_property(tada.text, ^"text_cutoff", 29, 0.8)
	win_tween.tween_interval(1)
	win_tween.tween_property(%overlay, ^"color:a", 1, 0.8)
	win_tween.tween_interval(0.4)
	await get_tree().create_timer(0.6).timeout
	fish.scale = Vector2.ONE * 0.8
	fish.texture = preload("res://assets/level_4/real_fish.png")
	await win_tween.finished
	game.end()

func _process(_delta) -> void:
	%camera.position = %player.position
	%stars.position = %camera.get_screen_center_position() * 0.2
	%stars_bg.position = %camera.get_screen_center_position() * 0.1

func summon_black_hole(target_range:float) -> void:
	var black_hole = BlackHole.new()
	black_hole.target_range = target_range
	black_hole.fish = %bar.fish
	%world.add_child(black_hole)
	black_hole.position = %bar.fish.position
	%bar.player.black_holes.append(black_hole)

func summon_comet() -> void:
	var comet:Comet = preload("res://scenes/comet.tscn").instantiate()
	var direction:float = randf_range(0, TAU)
	comet.fish = %bar.fish
	%world.add_child(comet)
	comet.position = %bar.player.position + Vector2(-1000,0).rotated(direction)
	comet.velocity = Vector2(1000,0).rotated(direction)
	comet.rotation = direction + PI/2
