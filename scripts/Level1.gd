extends Level
class_name Level1

func win() -> void:
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 0, 0.3)
	tween.tween_callback(func(): game.win_text.visible = true)
