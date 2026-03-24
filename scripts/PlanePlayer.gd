extends Player
class_name PlanePlayer

func half_height() -> float: return 64

func _ready() -> void: pass

func _process(delta: float) -> void:
	if !active: return
	velocity.y += delta * lerp(50, 100, position.y/bar.size.y) # gravity
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): velocity.y += delta * -350
		
	position += velocity * delta

	if position.y < half_height(): # bounce off top
		position.y = half_height()
		if velocity.y < 0: velocity.y *= -0.8
	if position.y > bar.size.y - half_height(): # bounce off bottom
		position.y = bar.size.y - half_height()
		if velocity.y > 0: velocity.y *= -0.8
	
	%velocityArrow.position = velocity/5
	%velocityArrow.polygon[2] = (abs(velocity)/10).max(Vector2.ONE*10) * sign(velocity)
	%velocityArrow.visible = velocity.length_squared() > 5
	%velocityLine.set_point_position(1,velocity/5)
	var speed_color:Color = Color.GREEN.blend(Color(Color.RED, abs(velocity.y/400)))
	%velocityArrow.color = speed_color
	%velocityLine.default_color = speed_color

	%sprite.rotation = velocity.y * 0.002

func _input(event: InputEvent) -> void:
	if !active: return
	if event is InputEventKey and event.pressed and !event.echo:
		match event.keycode:
			KEY_SPACE:
				velocity.y *= -lerp(0.4, 0.8, (position.y+648)/bar.size.y)
