extends Fish
class_name SharkFish

const PHASES:Array[float] = [0, 0.5, 1]

func start() -> void:
	position.x = bar.size.x/2

func phase_increased() -> void:
	pass
