extends Fish
class_name StarFish

const STATE_TARGET:int = 2
const STATE_SPECIAL:int = 3

const RADIUS:float = 13

const PHASES:Array[float] = [0, 0.25, 0.5, 0.75, 1]

const PLAYER_INFLUENCE:float = 128

func start() -> void:
	create_looping_timer(STATE_NONE, 15, func() -> void:
		if has_state(STATE_SPECIAL): return
		orbit(100, 0, 0.2, 8, 1, true)
		await get_tree().create_timer(0.3).timeout
		orbit(240, 3, -0.1, 16, 2)
		if phase > 0:
			await get_tree().create_timer(0.3).timeout
			orbit(400, 5, 0.2, 24, 3)
	)
	target()

func phase_increased() -> void: pass

func progress_increment() -> float:
	var distance:float = abs(position.y - bar.player.position.y)
	if distance <= PLAYER_INFLUENCE: return (PLAYER_INFLUENCE-distance)/PLAYER_INFLUENCE/60
	return 1.0/90

func touching_player() -> bool: return position.distance_squared_to(bar.player.position) < PLAYER_INFLUENCE**2

func target() -> void:
	var target_timer:ProcessTimer = create_oneshot_process_timer(STATE_TARGET, randf_range(1.5, 2), target)
	var target_position:Vector2 = Vector2(randf_range(RADIUS,bar.size.x-RADIUS), randf_range(RADIUS,bar.size.y-RADIUS))
	while !is_target_okay(target_position):
		target_position = Vector2(randf_range(RADIUS,bar.size.x-RADIUS), randf_range(RADIUS,bar.size.y-RADIUS))
	target_timer.process_function = func(delta:float) -> void:
		velocity += ((target_position-position) - velocity) * delta * targetting_speed()
		if velocity.length_squared() > 100: velocity += velocity.normalized() * -100 * delta

func is_target_okay(target_position:Vector2) -> bool:
	var distance_squared:float = target_position.distance_squared_to(position)
	return distance_squared > 10000

func targetting_speed() -> float:
	return 0.6 if phase >= 1 else 0.3

func orbit(radius:float, rotation_phase:float, speed:float, asteroid_count:int, gaps:int, new_target:bool=false) -> void:
	cancel_timers(STATE_TARGET)
	var orbit_position:Vector2
	if new_target:
		orbit_position = Vector2(randf_range(RADIUS,bar.size.x-RADIUS), randf_range(RADIUS,bar.size.y-RADIUS))
		while !is_orbit_okay(orbit_position):
			orbit_position = Vector2(randf_range(RADIUS,bar.size.x-RADIUS), randf_range(RADIUS,bar.size.y-RADIUS))
		velocity = Vector2.ZERO

	var circle:Circle = Circle.new()
	add_child(circle)

	var asteroids:Array[Asteroid] = []
	for i in asteroid_count:
		var asteroid:Asteroid = preload("res://scenes/asteroid.tscn").instantiate()
		asteroid.speed = speed
		@warning_ignore("integer_division")
		asteroid.phase = (i + int(i*gaps/asteroid_count)*3) * TAU/(asteroid_count+gaps*3) + rotation_phase
		asteroid.fish = self
		asteroids.append(asteroid)
		circle.add_child(asteroid)

	create_oneshot_timer(STATE_NONPROGRESS, 0.5, func():
		create_looping_timer_with_id(STATE_NONPROGRESS, 0.1, func(timer_id:int):
			if touching_player(): cancel_timer(timer_id, "star")
		)
	)
	var timer:ProcessTimer = create_oneshot_process_timer(STATE_SPECIAL, 0.6, func():
		var tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(circle, ^"color:a", 0.8, 0.8)
		tween.parallel().tween_property(circle, ^"radius", radius, 0.8)
		tween.parallel().tween_property(circle, ^"orbit_radius", radius, 0.8)
		tween.parallel().tween_property(circle, ^"asteroid_opacity", 1, 0.8)
		create_oneshot_timer(STATE_SPECIAL, 10, func():
			var end_tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			end_tween.tween_property(circle, ^"color:a", 0, 0.2)
			end_tween.parallel().tween_property(circle, ^"radius", 16, 0.8)
			end_tween.parallel().tween_property(circle, ^"orbit_radius", 4000, 1.4)
			end_tween.tween_callback(func(): circle.queue_free())
			target()
		)
	)
	if new_target: timer.process_function = func(delta): position = orbit_position - (orbit_position - position) * 0.1**delta
	else: timer.process_function = func(_delta): pass

func is_orbit_okay(target_position:Vector2) -> bool:
	var distance_squared:float = target_position.distance_squared_to(position)
	if phase < 1: return distance_squared > 1e6
	else: return distance_squared > 1e7

func asteroid_bumped() -> void:
	penalty(1)
	bar.player.velocity *= -1
