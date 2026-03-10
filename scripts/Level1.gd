extends Level
class_name Level1

var tilt_velocity:float = 0
var tilt:float = 0

func start() -> void:
	%bar.start()

func _process(delta: float) -> void:
	tilt_velocity += (%bar.size.y*0.3 - %bar.player.position.y) * delta * 0.04
	tilt_velocity *= 0.97
	tilt += tilt_velocity * delta
	if tilt > 10:
		tilt = 10
		if tilt_velocity > 0: tilt_velocity *= -0.6
	if tilt < -2:
		tilt = -2
		if tilt_velocity < 0: tilt_velocity *= -0.6
	%pivot.rotation = tilt * 0.05

func win() -> void:
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 0, 0.3)
	tween.tween_callback(func(): game.win_text.visible = true)
