extends AnimatedSprite2D
class_name Bird

var fish:SkyFish
var velocity:Vector2

func _ready() -> void:
	play()

func _process(delta:float) -> void:
	velocity += (fish.position - position) * delta * 0.05
	if velocity.length_squared() > 100: velocity += velocity.normalized() * -100 * delta
	velocity.y = clamp(velocity.y, -8, 8)
	position += velocity * 144 * delta

func _bumped(area:Area2D) -> void:
	if area.get_parent() is Player: fish.bird_hit_player()
