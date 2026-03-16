extends Fish
class_name CatFish

const STATE_TARGET:int = 2

const PHASES:Array[float] = [0, 0.5, 1]

func start() -> void:
	position.x = bar.size.x/2
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

func targetting_speed() -> float:
	return 0.6 if phase >= 1 else 0.3
