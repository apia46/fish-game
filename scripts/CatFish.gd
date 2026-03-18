extends Fish
class_name CatFish

const STATE_TARGET:int = 2
const STATE_SWIPE:int = 3

const PHASES:Array[float] = [0, 0.5, 1]

func start() -> void:
	position.x = bar.size.x/2
	create_looping_timer(STATE_NONE, 0.4, func() -> void:
		if randf() < 0.4 and !has_state(STATE_SWIPE) and position.y < bar.size.y*0.7 and position.y > bar.size.y*0.3:
			swipe()
	)
	target()

func phase_increased() -> void:
	pass

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
	return 0.6 if phase >= 1 else 0.3

func swipe() -> void:
	print("swipe")
	cancel_timers(STATE_TARGET)
	var direction:int = 1 if randf() > 0.5 else -1
	%telegraph.position.y = 10*direction
	%telegraph.rotation_degrees = 90+90*direction
	%telegraph.angle_min = %telegraph.rotation_degrees
	%telegraph.angle_max = %telegraph.rotation_degrees
	%telegraph.emitting = true
	await get_tree().process_frame
	%telegraph.emitting = false
	create_oneshot_timer(STATE_NONPROGRESS, 1, func():return)
	create_oneshot_process_timer(STATE_SWIPE, 1.6, target).process_function = func(delta):
		velocity *= 0.1**delta
	await get_tree().create_timer(0.7).timeout
	%swipe.modulate.a = 1
	%swipe.position.y = 0
	%swipe.rotation_degrees = 90+90*direction
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(%swipe, ^"modulate:a", 0, 1)
	tween.parallel().tween_property(%swipe, ^"position:y", direction*50, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
