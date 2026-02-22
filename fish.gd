extends Sprite2D
class_name Fish

@onready var game:Game = $"/root/game"
@onready var bar:Bar = get_parent()
@onready var collision:Area2D = %collision

enum STATE {TARGET}

const HALF_HEIGHT:float = 16

var time:float = 0
var progress:float = 0
var time_unhooked:float = 0
var velocity:Vector2 = Vector2.ZERO

var state:STATE = STATE.TARGET

var target:Vector2 = Vector2.ZERO # target position
var next_target_timer:float = 0

var dash_attack_timer:float = 0
var dash_direction:int = 0

func _process(delta: float) -> void:
	time += delta
	
	match state:
		STATE.TARGET:
			next_target_timer -= delta
			if next_target_timer <= 0: new_target()
			velocity += ((target-position) - velocity) * delta
	
	position += velocity * delta
	position.y = max(min(position.y, bar.size.y-HALF_HEIGHT), HALF_HEIGHT)

	if bar.player.collision in %collision.get_overlapping_areas():
		progress = min(progress + delta / 30, 1)
	else:
		progress = max(progress - delta / 30, 0)
		time_unhooked += delta
	progress = max(min(progress, 1), 0)
	game.progress_bar.value = progress
	game.accuracy_label.text = "Accuracy: %.1f%%" % ((1 - time_unhooked/time) * 100)

func _physics_process(delta:float) -> void:
	if dash_attack_timer:
		dash_attack_timer -= delta
		if dash_attack_timer <= 0:
			dash_attack_timer = 0
			velocity.y = dash_direction * 100
			if state == STATE.TARGET: new_target()
	elif randf() < 0.01 and velocity.length_squared() > 2000 and velocity.length_squared() < 10000:
		var tween:Tween = get_tree().create_tween()
		tween.tween_property(self, ^"rotation", randf_range(0.4, 1), 0.2).set_ease(Tween.EASE_IN)
		tween.tween_property(self, ^"rotation", 0, 0.2).set_ease(Tween.EASE_OUT)
		dash_attack_timer = 0.4
		dash_direction = -sign(velocity.y)

func new_target() -> void:
	target.x = bar.size.x/2
	while target.distance_squared_to(position) < 10000:
		target.y = randf_range(HALF_HEIGHT,bar.size.y-HALF_HEIGHT)
	next_target_timer = randf_range(1.5, 2)
