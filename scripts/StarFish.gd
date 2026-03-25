extends Fish
class_name StarFish

const STATE_TARGET:int = 2

const RADIUS:float = 13

const PHASES:Array[float] = [0, 0.5, 1]

func start() -> void:
	target()

func phase_increased() -> void: pass

func progress_increment() -> float: return 1.0/90

func target() -> void:
	var target_timer:ProcessTimer = create_oneshot_process_timer(STATE_TARGET, randf_range(1.5, 2), target)
	var target_position:Vector2 = Vector2(randf_range(RADIUS,bar.size.x-RADIUS), randf_range(RADIUS,bar.size.y-RADIUS))
	while !is_target_okay(target_position):
		target_position = Vector2(randf_range(RADIUS,bar.size.x-RADIUS), randf_range(RADIUS,bar.size.y-RADIUS))
	target_timer.process_function = func(delta:float) -> void:
		velocity += ((target_position-position) - velocity) * delta * targetting_speed()

func is_target_okay(target_position:Vector2) -> bool:
	var distance_squared:float = target_position.distance_squared_to(position)
	if has_state(STATE_NONPROGRESS): return distance_squared > 100 and distance_squared < 5000
	return distance_squared > 10000

func targetting_speed() -> float:
	return 0.6 if phase >= 1 else 0.3
