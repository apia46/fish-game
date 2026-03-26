extends Node2D
class_name Player

@onready var game:Game = $"/root/game"
@onready var bar:Bar = get_parent()
var collision:Area2D

var velocity:Vector2 = Vector2.ZERO

var active:bool = false

var stretch_y:float = 1

var black_holes:Array[BlackHole] = []

func _ready() -> void:
	collision = %collision

func half_height() -> float:
	return 64 * stretch_y

func _process(delta: float) -> void:
	if !active: return
	velocity.y += delta * 100
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): velocity.y += delta * -350
		
	position += velocity * delta
	stretch_y += (min(0.8+abs(velocity.y)*0.001, 1.2) - stretch_y) * 0.3

	if position.y < half_height(): # bounce off top
		position.y = half_height()
		if velocity.y < 0: velocity.y *= -0.8
	if position.y > bar.size.y - half_height(): # bounce off bottom
		position.y = bar.size.y - half_height()
		if velocity.y > 0: velocity.y *= -0.8
	
	%velocityLine.position.y = half_height() * sign(velocity.y)
	%velocityArrow.position = velocity/5
	%velocityArrow.polygon[2] = (abs(velocity)/10).max(Vector2.ONE*10) * sign(velocity)
	%velocityArrow.visible = velocity.length_squared() > 5
	%velocityLine.set_point_position(1,velocity/5)
	var speed_color:Color = Color.GREEN.blend(Color(Color.RED, abs(velocity.y/400)))
	%velocityArrow.color = speed_color
	%velocityLine.default_color = speed_color

	%collision.scale.y = stretch_y
	%texture.size.y = 128*stretch_y
	%texture.position.y = -64*stretch_y

func _input(event: InputEvent) -> void:
	if !active: return
	if event is InputEventKey and event.pressed and !event.echo:
		match event.keycode:
			KEY_SPACE:
				velocity.y *= -0.8
				if bar.fish is TutorialFish:
					var tutorial:Tutorial = game.level
					if tutorial.dash_tutorialing: tutorial.dash_tutorial_finish()
					elif !tutorial.dash_tutorialed: tutorial.dash_tutorial_skip()
				if bar.fish.collision in %collision.get_overlapping_areas(): bar.fish.progress += bar.fish.progress_increment() * 0.2
