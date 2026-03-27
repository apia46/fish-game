extends Fish
class_name SharkFish

const STATE_TARGET:int = 2
const STATE_DASH:int = 3

const PHASES:Array[float] = [0, 0.5, 1]

func start() -> void:
	position.x = bar.size.x/2
	target()
	create_looping_timer(STATE_NONE, 0.4, func() -> void:
		if randf() < dash_probability() and !has_state(STATE_DASH) and position.y < bar.size.y*0.75 and position.y > bar.size.y*0.25:
			dash()
			if phase > 0:
				for i in randi_range(1,3):
					await get_tree().create_timer(0.4).timeout
					dash()
	)

func progress_increment() -> float: return 1.0/50

func dash_probability() -> float:
	return 0.8 if phase >= 1 else 0.4

func target() -> void:
	var target_timer:ProcessTimer = create_oneshot_process_timer(STATE_TARGET, randf_range(1.5, 2), target)
	var target_position:Vector2 = Vector2(bar.size.x/2, randf_range(HALF_HEIGHT,bar.size.y-HALF_HEIGHT))
	while !is_target_okay(target_position):
		target_position.y = randf_range(HALF_HEIGHT,bar.size.y-HALF_HEIGHT)
	target_timer.process_function = func(delta:float) -> void:
		velocity += ((target_position-position) - velocity) * delta * targetting_speed()
		velocity.x = 0

func is_target_okay(target_position:Vector2) -> bool:
	var distance_squared:float = target_position.distance_squared_to(position)
	return distance_squared > 10000

func targetting_speed() -> float:
	return 0.66 if phase >= 1 else 0.5

func dash() -> void:
	cancel_timers(STATE_TARGET)
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, ^"rotation", randf_range(0.4, 1), 0.2).set_ease(Tween.EASE_IN)
	tween.tween_property(self, ^"rotation", 0, 0.2).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.3).timeout
	velocity = sign(velocity) * -200

	create_oneshot_timer(STATE_NONPROGRESS, 0.5, func():
		create_looping_timer_with_id(STATE_NONPROGRESS, 0.1, func(timer_id:int):
			if touching_player(): cancel_timer(timer_id, "shark")
		)
	)
	var dash_timer:ProcessTimer = create_oneshot_process_timer(STATE_DASH, 1, target)
	dash_timer.process_function = func(delta:float) -> void:
		velocity -= sign(velocity) * delta * 80

func phase_increased() -> void:
	if phase == 1:
		texture = preload("res://assets/level_1/shark_fish_2.png")

func get_stats() -> String: return "Shark Fish: %.1fs / %.1f%%" % [real_time, (1 - time_unhooked/time)*100]
