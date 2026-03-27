extends Sprite2D
class_name StarFishAllure

var rot:float:
	set(to):
		rot = to
		rotation = to
		%particles.process_material.direction = xy(Vector2(1,0).rotated(to))

var velocity:float = 0

func _process(delta: float) -> void:
	position += Vector2(-velocity,0).rotated(rot) * delta

static func xy(v:Vector2) -> Vector3: return Vector3(v.x, v.y, 0)
