extends Sprite2D
class_name Lilypad

@export var speed:float = 1
@export var period_offset:float
var time:float

func _process(delta: float) -> void:
	time += delta * speed
	if time >= TAU: time -= TAU
	offset.y = cos(time+period_offset)*2
