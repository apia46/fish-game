extends Fish
class_name CatFish

const STATE_TARGET:int = 2
const STATE_SPECIAL:int = 3
const STATE_ZOOMIES:int = 4

const PHASES:Array[float] = [0, 1.0/3, 2.0/3, 1]

func start() -> void:
	position.x = bar.size.x/2
	create_looping_timer(STATE_NONE, 0.6, func() -> void:
		if has_state(STATE_SPECIAL): return
		if randf() < swipe_probability() and position.y < bar.size.y*0.7 and position.y > bar.size.y*0.3:
			swipe(phase+1)
		elif randf() < 0.2 and phase > 0 and position.y < bar.size.y*0.7 and position.y > bar.size.y*0.3:
			zoomies()
	)
	target()

func progress_increment() -> float: return 1.0/80

func phase_increased() -> void:
	if phase == 1:
		texture = preload("res://assets/level_2/catfish_1.png")
	elif phase == 2:
		texture = preload("res://assets/level_2/catfish_2.png")

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

func zoomies() -> void:
	cancel_timers(STATE_TARGET)
	var direction:int = 1 if randf() > 0.5 else -1
	create_looping_timer(STATE_ZOOMIES, 0.05, func(): rotation = randf_range(-0.1, 0.1))
	await create_oneshot_process_timer(STATE_SPECIAL, 0.5).with_function(func(delta): velocity *= 0.1**delta).timeout
	for i in randf_range(6,10):
		await create_oneshot_process_timer(STATE_SPECIAL, randf_range(0.1, 1.5)).with_function(func(delta): velocity.y += direction*40*delta).timeout
		direction *= -1
		velocity.y *= -0.9
	cancel_timers(STATE_ZOOMIES)
	target()

func swipe_probability() -> float:
	match phase:
		0: return 0.3
		1: return 0.25
		2, _: return 0.2

func swipe(times:int) -> void:
	cancel_timers(STATE_TARGET)
	create_oneshot_process_timer(STATE_SPECIAL, 0.5+1.3*times, target).process_function = func(delta):
			velocity *= 0.1**delta
			level.swipe.position = position
	create_oneshot_timer(STATE_NONPROGRESS, 0.6+1.3*times)
	var directions:Array[int] = []
	var direction:int = 1 if randf() > 0.5 else -1
	for i in times:
		directions.append(direction)
		add_child(Telegraph.new(direction))
		await get_tree().create_timer(0.3).timeout
		direction = direction*-1 if randf() > 0.2 else direction
	await get_tree().create_timer(0.9).timeout
	for i in times:
		direction = directions[i]
		if (bar.player.position.y-position.y) * direction > 0:
			hit()
		level.swipe.modulate.a = 1
		level.swipe.offset.y = -40
		level.swipe.rotation_degrees = 90+90*direction
		var tween:Tween = get_tree().create_tween()
		tween.tween_property(level.swipe, ^"modulate:a", 0, 0.6)
		tween.parallel().tween_property(level.swipe, ^"offset:y", -90, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		game.level.cat_swipe()
		await get_tree().create_timer(0.9).timeout

func hit() -> void:
	penalty(1)

class Telegraph extends Sprite2D:
	func _init(direction:int) -> void:
		position.y = 10*direction
		rotation_degrees = 90+90*direction
		scale = Vector2(2,2)
		texture = preload("res://assets/level_2/telegraph.png")
	
	func _ready() -> void:
		var tween:Tween = get_tree().create_tween()
		tween.tween_property(self, ^"modulate:a", 0, 0.6)
		tween.parallel().tween_property(self, ^"offset:y", -10, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_callback(queue_free)

func get_stats() -> String: return "Cat Fish: %.1fs / %.1f%%" % [real_time, (1 - time_unhooked/time)*100]
