extends Fish
class_name SkyFish

const STATE_TARGET:int = 2

const PHASES:Array[float] = [0, 0.25, 0.5, 0.75, 1]

const PLAYER_INFLUENCE:float = 150

func start() -> void:
	position.x = bar.size.x/2
	target()

func touching_player() -> bool: return abs(position.y - bar.player.position.y) < PLAYER_INFLUENCE

func phase_increased() -> void:
	if phase == 1:
		cancel_timers(STATE_TARGET)
		await get_tree().create_timer(0.3).timeout
		target(400)

func progress_increment() -> float:
	var distance:float = abs(position.y - bar.player.position.y)
	if distance <= PLAYER_INFLUENCE: return (PLAYER_INFLUENCE-distance)/PLAYER_INFLUENCE/60
	return 1.0/60

func target(set_target:float=NAN) -> void:
	var target_timer:ProcessTimer = create_oneshot_process_timer(STATE_TARGET, randf_range(1.5, 2), target)
	var target_position:Vector2 = Vector2(bar.size.x/2, new_target_height())
	if is_nan(set_target):
		while !is_target_okay(target_position):
			target_position.y = new_target_height()
	else: target_position.y = set_target
	print(target_position.y)
	target_timer.process_function = func(delta:float) -> void:
		velocity += ((target_position-position) - velocity) * delta * targetting_speed()
		velocity.x = 0

func new_target_height() -> float:
	if phase == 0: return randf_range(bar.size.y-600+HALF_HEIGHT,bar.size.y-HALF_HEIGHT-100)
	else: return randf_range(max(HALF_HEIGHT+200, position.y-500), min(bar.size.y-HALF_HEIGHT-100, position.y+500))

func is_target_okay(target_position:Vector2) -> bool:
	var distance_squared:float = target_position.distance_squared_to(position)
	return distance_squared > 10000

func targetting_speed() -> float:
	return 0.66 if phase >= 2 else 0.4