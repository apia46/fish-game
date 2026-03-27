extends Level
class_name Level3

func start() -> void:
	if !game.skip_tutorials:
		await GamePopup.create(self, "The plane has a bigger area of affect.", "Okay").closed
		await GamePopup.create(self, "Progress increases faster the closer the fish is to the center of the area.", "Okay").closed
	%bar.start()

func _process(_delta) -> void:
	if %bar.fish.phase > 1:
		%camera.position.y = %player.position.y

func win() -> void:
	game.stats.append(%bar.fish.get_stats())
	%bar.fish.active = false
	%bar.fish.cancel_all_timers()
	%bar.player.cutscene = true
	for bird in %birds.get_children(): bird.cutscene = true

	await get_tree().create_timer(1).timeout

	var center:Vector2 = %camera.get_screen_center_position() - %bar.global_position

	var tada:Tada = Game.new_tada("You caught a... hey where are you going")
	%bar.add_child(tada)
	tada.position = center
	%bar.fish.z_index = 2

	var win_tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	win_tween.parallel().tween_property(%bar.player.panel, ^"modulate:a", 0, 0.5)
	win_tween.parallel().tween_property(%bar.fish, ^"position", center, 0.8)
	win_tween.parallel().tween_property(%bar.fish, ^"rotation", TAU*2, 0.8)
	win_tween.parallel().tween_property(%bar.fish, ^"scale", Vector2.ONE*3, 0.5)
	win_tween.parallel().tween_property(tada.sprite, ^"scale", Vector2.ONE*4, 0.8)
	win_tween.parallel().tween_property(tada.sprite, ^"rotation", TAU, 0.8)
	win_tween.parallel().tween_property(tada.text, ^"start_offset", 160, 0.8)
	win_tween.parallel().tween_property(tada.text, ^"text_cutoff", 15, 0.8)
	win_tween.tween_interval(1)
	win_tween.tween_property(tada.text, ^"text_cutoff", 19, 0.4)
	win_tween.tween_interval(0.4)
	win_tween.tween_property(tada.text, ^"text_cutoff", 40, 1.2)
	win_tween.tween_property(%overlay, ^"color:a", 1, 0.8)
	win_tween.tween_interval(0.4)
	await get_tree().create_timer(0.6).timeout
	%bar.fish.scale = Vector2.ONE * 0.3
	%bar.fish.texture = preload("res://assets/level_3/real_fish.png")

	await get_tree().create_timer(0.2).timeout
	var starfish:Sprite2D = preload("res://scenes/starfish_allure.tscn").instantiate()
	%bar.add_child(starfish)
	starfish.position = center + Vector2(400, -400)
	var fish_tween:Tween = get_tree().create_tween()
	starfish.velocity = 400
	starfish.rot = 4.3
	fish_tween.tween_property(starfish, ^"rot", 8, 2)

	await get_tree().create_timer(0.4).timeout
	var speed_tween:Tween = get_tree().create_tween()
	speed_tween.tween_property(%bar.player, ^"cutscene_velocity", 500, 1)
	speed_tween.tween_property(starfish, ^"velocity", 600, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	var player_rotate_tween:Tween = get_tree().create_tween()
	player_rotate_tween.tween_property(%bar.player, ^"cutscene_direction", 0.3, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	player_rotate_tween.tween_property(%bar.player, ^"cutscene_direction", -PI/2, 1.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	await win_tween.finished
	game.start_level(preload("res://scenes/level_4.tscn"))

func summon_bird() -> void:
	var bird:Bird = preload("res://scenes/bird.tscn").instantiate()
	bird.fish = %bar.fish
	%birds.add_child(bird)
	bird.position = Vector2(1400, randf_range(1000, 1500))

func bird_warning() -> void:
	if game.skip_tutorials: return
	%bar.player.active = false
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 0, 0.3)
	await tween.finished
	await GamePopup.create(self, "Warning: Bird", "Oh no").closed
	await GamePopup.create(self, "Avoid Bird", "I will try").closed
	tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 1, 0.3)
	%bar.player.active = true
