extends Player
class_name SpacePlayer

const EDGE_MARGIN:float = -50

func _process(delta: float) -> void:
	if !active: return
	var direction:Vector2 = get_local_mouse_position().normalized()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		velocity += direction * delta * 350
		
	position += velocity * delta

	if position.y < EDGE_MARGIN: # bounce off top
		position.y = EDGE_MARGIN
		if velocity.y < 0: velocity.y *= -0.8
	if position.y > bar.size.y - EDGE_MARGIN: # bounce off bottom
		position.y = bar.size.y - EDGE_MARGIN
		if velocity.y > 0: velocity.y *= -0.8
	if position.x < EDGE_MARGIN: # bounce off left
		position.x = EDGE_MARGIN
		if velocity.x < 0: velocity.x *= -0.8
	if position.x > bar.size.x - EDGE_MARGIN: # bounce off right
		position.x = bar.size.x - EDGE_MARGIN
		if velocity.x > 0: velocity.x *= -0.8

	%velocityArrow.position = velocity/5
	
	var velocity_magnitude:float = velocity.length()
	%velocityArrow.rotation = velocity.angle() - PI/2
	%velocityArrow.polygon[2].y = max(velocity_magnitude/10, 10)
	%velocityArrow.visible = velocity.length_squared() > 5
	%velocityLine.set_point_position(1,velocity/5)
	var speed_color:Color = Color.GREEN.blend(Color(Color.RED, velocity_magnitude/400))
	%velocityArrow.color = speed_color
	%velocityLine.default_color = speed_color

func _input(event: InputEvent) -> void:
	if !active: return
	if event is InputEventKey and event.pressed and !event.echo:
		match event.keycode:
			KEY_SPACE:
				velocity = velocity.rotated(velocity.angle_to(get_local_mouse_position())) * 0.8
				if bar.fish.collision in %collision.get_overlapping_areas(): bar.fish.progress += bar.fish.progress_increment() * 0.2
