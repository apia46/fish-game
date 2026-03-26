extends Level
class_name Level3

func start() -> void:
	await GamePopup.create(self, "The plane has a bigger area of affect than the rod.", "Oh hi again").closed
	await GamePopup.create(self, "Progress increases faster the closer the fish is to the center of the area.", "Okay").closed
	%bar.start()

func _process(_delta) -> void:
	if %bar.fish.phase > 1:
		%camera.position.y = %player.position.y

func win() -> void:
	game.win_text.visible = true
	%bar.stop()

	await get_tree().create_timer(0.5).timeout
	game.win_text.visible = false
	game.start_level(preload("res://scenes/level_4.tscn"))

func summon_bird() -> void:
	var bird:Bird = preload("res://scenes/bird.tscn").instantiate()
	bird.fish = %bar.fish
	%birds.add_child(bird)
	bird.position = Vector2(1400, randf_range(1000, 1500))

func bird_warning() -> void:
	%bar.player.active = false
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 0, 0.3)
	await tween.finished
	await GamePopup.create(self, "Warning: Bird", "Oh no").closed
	await GamePopup.create(self, "Avoid Bird", "I will try").closed
	tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 1, 0.3)
	%bar.player.active = true
