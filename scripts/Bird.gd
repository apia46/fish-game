extends AnimatedSprite2D
class_name Bird

var fish:SkyFish
var velocity:Vector2

var cutscene:bool = false

func _ready() -> void:
	play()

func _process(delta:float) -> void:
	if !cutscene:
		velocity += (fish.position - position) * delta * 0.05
		if velocity.length_squared() > 100: velocity += velocity.normalized() * -100 * delta
		velocity.y = clamp(velocity.y, -8, 8)
	if cutscene:
		velocity.x -= 100 * delta
	position += velocity * 144 * delta

func _bumped(area:Area2D) -> void:
	if area.get_parent() is Player: fish.bird_hit_player()
