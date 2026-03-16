extends Sprite2D
class_name Cattail

@export var speed:float = 1
@export var period_offset:float
var time:float

func _process(delta: float) -> void:
	time += delta * speed
	if time >= TAU: time -= TAU
	rotation = cos(time+period_offset)*0.1
