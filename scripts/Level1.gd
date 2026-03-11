extends Level
class_name Level1

var tilt_velocity:float = 0
var tilt:float = 0
var interior_tilt:float = 0
var interior_tilt_velocity:float = 0

@onready var pivot:Control = %pivot

func start() -> void:
	%bar.start()

func _process(delta: float) -> void:
	tilt_velocity += (%bar.size.y*0.3 - %bar.player.position.y) * delta * 0.04
	tilt += tilt_velocity * delta
	if tilt > 10:
		tilt = 10
		fail()
	%wheel.rotation = tilt_velocity * 2
	%bg_pivot.rotation = tilt * -0.05
	interior_tilt_velocity += (tilt - interior_tilt) * delta
	interior_tilt += interior_tilt_velocity * delta
	%pivot.rotation += ((interior_tilt-tilt) * -0.05 - %pivot.rotation) * 5 * delta

func _physics_process(_delta) -> void:
	tilt_velocity *= 0.97
	if tilt < -2 and tilt_velocity <= 0:
		tilt_velocity *= max(0,-4/tilt-1)
	interior_tilt_velocity *= 0.99

func fail() -> void:
	pass

func win() -> void:
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 0, 0.3)
	tween.tween_callback(func(): game.win_text.visible = true)
