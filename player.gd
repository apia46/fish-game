extends Node2D
class_name Player

@onready var bar:Bar = get_parent()
@onready var collision:Area2D = %collision

var velocity:Vector2 = Vector2.ZERO

var active:bool = false

func half_height() -> float:
	return 64 * %scale.scale.y

func _process(delta: float) -> void:
	if !active: return
	velocity.y += delta * 100 # gravity
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): velocity.y += delta * -350
		
	position += velocity * delta
	%scale.scale.y += (min(0.8+abs(velocity.y)*0.001, 1.2) - %scale.scale.y) * 0.3

	if position.y < half_height(): # bounce off top
		position.y = half_height()
		if velocity.y < 0: velocity.y *= -0.8
	if position.y > bar.size.y - half_height(): # bounce off bottom
		position.y = bar.size.y - half_height()
		if velocity.y > 0: velocity.y *= -0.8
	
	%velocityLine.position.y = half_height() * sign(velocity.y)
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
