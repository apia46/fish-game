extends Sprite2D
class_name Comet

var fish:StarFish

var velocity:Vector2

func _bumped(area: Area2D) -> void:
	if area.get_parent() is Player: fish.asteroid_bumped(1)

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	queue_free()

func _process(delta:float) -> void:
	position += velocity*delta
