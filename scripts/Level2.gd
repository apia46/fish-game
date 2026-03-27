extends Level
class_name Level2

@onready var swipe:Sprite2D = %swipe

func start() -> void:
	if !game.skip_tutorials:
		await GamePopup.create(self, "Avoid the fish's swipes.", "Okay").closed
		await GamePopup.create(self, "Swipes are telegraphed before they happen.", "Okay").closed
	%bar.start()

func win() -> void:
	game.stats.append(%bar.fish.get_stats())
	%bar.stop()

	await get_tree().create_timer(0.5).timeout

	var center:Vector2 = Vector2(576, 324) - %n.global_position

	var tada:Tada = Game.new_tada("You caught your cat!")
	%n.add_child(tada)
	tada.position = center
	var fish = %bar.fish
	%bar.remove_child(fish)
	%n.add_child(fish)
	fish.z_index = 2
	Engine.time_scale = 0
	var win_tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ignore_time_scale()
	win_tween.parallel().tween_property(fish, ^"position", center, 0.8)
	win_tween.parallel().tween_property(fish, ^"rotation", TAU*2, 0.8)
	win_tween.parallel().tween_property(fish, ^"scale", Vector2.ONE*3, 0.5)
	win_tween.parallel().tween_property(tada.sprite, ^"scale", Vector2.ONE*4, 0.8)
	win_tween.parallel().tween_property(tada.sprite, ^"rotation", TAU, 0.8)
	win_tween.parallel().tween_property(tada.text, ^"start_offset", 160, 0.8)
	win_tween.parallel().tween_property(tada.text, ^"text_cutoff", 21, 0.8)
	win_tween.tween_callback(func():
		fish.scale = Vector2.ONE * 0.3
		fish.texture = preload("res://assets/level_2/real_fish.png")
	)
	win_tween.tween_interval(1)
	win_tween.tween_property(%overlay, ^"color:a", 1, 0.8)
	win_tween.tween_interval(0.4)
	await win_tween.finished
	Engine.time_scale = 1
	game.start_level(preload("res://scenes/level_3.tscn"))

func cat_swipe() -> void:
	%cat.frame = 0
	%cat.play(&"swipe")
	for i in 4:
		%cat.offset = Vector2(randi_range(-1,1), randi_range(-1,1))
		await get_tree().create_timer(0.05).timeout
		%cat.offset = Vector2.ZERO
