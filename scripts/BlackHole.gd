extends Sprite2D
class_name BlackHole

var velocity:Vector2
var time:float = 0.8

func _ready() -> void:
	scale = Vector2(0,0)
	var tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, ^"scale", Vector2.ONE, 0.8)
	texture = preload("res://assets/level_4/black_hole.png")

func _process(delta: float) -> void:
	time += delta
	if time > 0.8:
		time -= 0.8
		velocity = Vector2(60,0).rotated(randf_range(0,TAU))
	position += velocity * delta
	rotation += delta * 3
