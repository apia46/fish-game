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
	var add_velocity:float = (%bar.size.y*0.5 - %bar.player.position.y) * 0.025
	if abs(add_velocity) < 1: add_velocity = 0
	else: add_velocity -= 1 * sign(add_velocity)
	tilt_velocity += add_velocity * delta
	tilt += tilt_velocity * delta
	if abs(tilt) > 12:
		tilt = 12 * sign(tilt)
		tilt_velocity = sign(tilt) * -15
		fail()
	%wheel.rotation += (add_velocity-%wheel.rotation) * delta * 2
	%bg_pivot.rotation = tilt * -0.05
	interior_tilt_velocity += (tilt - interior_tilt) * delta
	interior_tilt += interior_tilt_velocity * delta
	%pivot.rotation += ((interior_tilt-tilt) * -0.05 - %pivot.rotation) * 5 * delta

func _physics_process(_delta) -> void:
	tilt_velocity *= 0.965
	interior_tilt_velocity *= 0.99

func fail() -> void:
	%bar.fish.penalty(16)

func win() -> void:
	game.win_text.visible = true
	%bar.stop()

	await get_tree().create_timer(0.5).timeout
	game.win_text.visible = false
	game.start_level(preload("res://scenes/level_2.tscn"))
