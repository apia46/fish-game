class_name TutorialFish
extends Fish

const STATE_TARGET:int = 2
const STATE_DASH:int = 3

const HALF_HEIGHT:float = 16

func _ready() -> void:
	target()
	create_looping_timer(STATE_NONE, 0.5, func() -> void:
		if randf() < 0.2 and velocity.length_squared() > 2000 and velocity.length_squared() < 10000 and !has_state(STATE_DASH):
			dash()
	)

func _process(delta: float) -> void:
	super(delta)

func target() -> void:
	var target_timer:ProcessTimer = create_oneshot_process_timer(STATE_TARGET, randf_range(1.5, 2), target)
	var target_position:Vector2 = Vector2(bar.size.x/2, randf_range(HALF_HEIGHT,bar.size.y-HALF_HEIGHT))
	while target_position.distance_squared_to(position) < 10000:
		target_position.y = randf_range(HALF_HEIGHT,bar.size.y-HALF_HEIGHT)
	target_timer.process_function = func(delta:float) -> void:
		velocity += ((target_position-position) - velocity) * delta * 0.7

func dash() -> void:
	cancel_timers(STATE_TARGET)
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, ^"rotation", randf_range(0.4, 1), 0.2).set_ease(Tween.EASE_IN)
	tween.tween_property(self, ^"rotation", 0, 0.2).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.3).timeout
	velocity = sign(velocity) * -100
	var dash_timer:ProcessTimer = create_oneshot_process_timer(STATE_DASH, 1, target)
	dash_timer.process_function = func(delta:float) -> void:
		velocity -= sign(velocity) * delta * 100
