extends Level
class_name Level1

var tilt_velocity:float = 0
var tilt:float = 0
var interior_tilt:float = 0
var interior_tilt_velocity:float = 0

@onready var pivot:Control = %pivot

var active:bool = false

func start() -> void:
	if !game.skip_tutorials:
		await GamePopup.create(self, "Warning: Being too far to the side tilts the boat.", "Kay").closed
		await GamePopup.create(self, "Avoid tilting the boat too far.", "Mhm").closed
		await GamePopup.create(self, "Note: this fish disengages every time it dashes.", "And?").closed
		await GamePopup.create(self, "When the fish is disengaged, you don't have to stay on it.", "Got it").closed
	active = true
	%bar.start()

func _process(delta: float) -> void:
	if !active: return
	var add_velocity:float = (%bar.size.y*0.5 - %bar.player.position.y) * 0.025
	if abs(add_velocity) < 1: add_velocity = 0
	else: add_velocity -= 1 * sign(add_velocity)
	tilt_velocity += add_velocity * delta
	tilt += tilt_velocity * delta
	if abs(tilt) > 11:
		tilt = 11 * sign(tilt)
		tilt_velocity = sign(tilt) * -15
		fail()
	%wheel.rotation += (add_velocity-%wheel.rotation) * delta * 2
	%bg_pivot.rotation = tilt * -0.05
	interior_tilt_velocity += (tilt - interior_tilt) * delta
	interior_tilt += interior_tilt_velocity * delta
	%pivot.rotation += ((interior_tilt-tilt) * -0.05 - %pivot.rotation) * 5 * delta

func _physics_process(_delta) -> void:
	tilt_velocity *= 0.965
	interior_tilt_velocity *= 0.99

func fail() -> void:
	%bar.fish.penalty(16)

func win() -> void:
	game.stats.append(%bar.fish.get_stats())
	%bar.stop()
	active = false

	await get_tree().create_timer(0.5).timeout

	var center:Vector2 = Vector2(576, 324)

	var tada:Tada = Game.new_tada("You caught an actual fish!")
	%end.add_child(tada)
	tada.position = center
	var fish = %bar.fish
	var fish_pos:Vector2 = fish.global_position
	%bar.remove_child(fish)
	%end.add_child(fish)
	fish.position = fish_pos
	fish.z_index = 2

	var win_tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	win_tween.parallel().tween_property(fish, ^"position", center, 0.8)
	win_tween.parallel().tween_property(fish, ^"rotation", TAU*2, 0.8)
	win_tween.parallel().tween_property(fish, ^"scale", Vector2.ONE*3, 0.5)
	win_tween.parallel().tween_property(tada.sprite, ^"scale", Vector2.ONE*4, 0.8)
	win_tween.parallel().tween_property(tada.sprite, ^"rotation", TAU, 0.8)
	win_tween.parallel().tween_property(tada.text, ^"start_offset", 150, 0.8)
	win_tween.parallel().tween_property(tada.text, ^"text_cutoff", 26, 0.8)
	win_tween.tween_interval(1)
	win_tween.tween_property(%overlay, ^"color:a", 1, 0.8)
	win_tween.tween_interval(0.4)
	await get_tree().create_timer(0.6).timeout
	fish.scale = Vector2.ONE
	fish.texture = preload("res://assets/level_1/real_fish.png")
	await win_tween.finished
	game.start_level(preload("res://scenes/level_2.tscn"))
