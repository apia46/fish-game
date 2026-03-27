extends Sprite2D
class_name BlackHole

var velocity:Vector2
var time:float = 0
var effect:float = 0

var target:Vector2
var fish:StarFish

var target_range:float

func _ready() -> void:
	scale = Vector2(0,0)
	target = fish.position + Vector2(800, 0).rotated(randf_range(0,TAU))
	var tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, ^"scale", Vector2.ONE, 0.8)
	tween.tween_interval(0.4)
	tween.tween_property(self, ^"effect", 1, 0.4)
	texture = preload("res://assets/level_4/black_hole.png")

func new_target() -> void:
	target = fish.position + Vector2(target_range, 0).rotated(randf_range(0,TAU))

func _process(delta: float) -> void:
	time += delta
	if time > 2:
		time -= 2
		new_target()
	velocity = (target - position) * 0.2
	position += velocity * delta
	rotation += delta * 8
