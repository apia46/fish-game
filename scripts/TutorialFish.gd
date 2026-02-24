class_name TutorialFish
extends Fish

const STATE_TARGET:int = 2
const STATE_DASH:int = 3

const HALF_HEIGHT:float = 16

func _ready() -> void:
	new_target()
	create_timer(STATE_NONE, 0.5, func() -> void:
		if randf() < 0.2 and velocity.length_squared() > 2000 and velocity.length_squared() < 10000:
			new_dash()
	)

func new_target() -> void:
	var target:ProcessTimer = create_oneshot_timer(STATE_TARGET, randf_range(1.5, 2), new_target, ProcessTimer)
	var target_position:Vector2 = Vector2(bar.size.x/2, 0)
	while target_position.distance_squared_to(position) < 10000:
		target_position.y = randf_range(HALF_HEIGHT,bar.size.y-HALF_HEIGHT)
	target.process_function = func(delta:float) -> void:
		velocity += ((target_position-position) - velocity) * delta

func new_dash() -> void:
	cancel_timers(STATE_TARGET)
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, ^"rotation", randf_range(0.4, 1), 0.2).set_ease(Tween.EASE_IN)
	tween.tween_property(self, ^"rotation", 0, 0.2).set_ease(Tween.EASE_OUT)
	velocity = sign(velocity) * -100
	var dash:ProcessTimer = create_timer(STATE_DASH, 0.5, new_target, ProcessTimer)
	dash.process_function = func(delta:float) -> void:
		velocity -= sign(velocity) * delta * 100
