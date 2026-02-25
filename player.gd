extends Node2D
class_name Player

@onready var bar:Bar = get_parent()
@onready var collision:Area2D = %collision

const HALF_HEIGHT:float = 64

var velocity:Vector2 = Vector2.ZERO

var active:bool = false

func _process(delta: float) -> void:
	if !active: return
	velocity.y += delta * 100 # gravity
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): velocity.y += delta * -350
		
	position += velocity * delta

	if position.y < HALF_HEIGHT: # bounce off top
		position.y = HALF_HEIGHT
		if velocity.y < 0: velocity.y *= -0.8
	if position.y > bar.size.y - HALF_HEIGHT: # bounce off bottom
		position.y = bar.size.y - HALF_HEIGHT
		if velocity.y > 0: velocity.y *= -0.8
	
	%velocityLine.position.y = 64 * sign(velocity.y)
	%velocityArrow.position = velocity/5
	%velocityArrow.polygon[2] = (abs(velocity)/10).max(Vector2.ONE*10) * sign(velocity)
	%velocityLine.set_point_position(1,velocity/5)
	var speed_color:Color = Color.GREEN.blend(Color(Color.RED, abs(velocity.y/400)))
	%velocityArrow.color = speed_color
	%velocityLine.default_color = speed_color

func _input(event: InputEvent) -> void:
	if !active: return
	if event is InputEventKey and event.pressed and !event.echo:
		match event.keycode:
			KEY_SPACE:
				velocity.y *= -0.8 # dash attack
				if bar.fish.collision in %collision.get_overlapping_areas(): bar.fish.bonus_progress += 0.2
