extends Player
class_name SpacePlayer

const EDGE_MARGIN:float = -50

func _ready() -> void:
	velocity = Vector2(0, -50)

func _process(delta: float) -> void:
	if !active: return
	var direction:Vector2 = get_local_mouse_position().normalized()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		velocity += direction * delta * 350

	for black_hole in black_holes:
		velocity += (black_hole.position - position).normalized() * delta * black_hole.effect * 1.4e7/max(black_hole.position.distance_squared_to(position), 40000)
	if velocity.length_squared() > 1e8: velocity += velocity.normalized() * -400 * delta

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

	
	var velocity_magnitude:float = velocity.length()
	%velocityArrow.position = Vector2(0,-velocity_magnitude/5)
	%velocityArrow.polygon[2].y = max(velocity_magnitude/10, 10)
	%velocityArrow.visible = velocity.length_squared() > 5
	%velocityLine.set_point_position(1,Vector2(0,-velocity_magnitude/5))
	var speed_color:Color = Color.GREEN.blend(Color(Color.RED, velocity_magnitude/400))
	%velocityArrow.color = speed_color
	%velocityLine.default_color = speed_color

	%sprite.rotation = velocity.angle() + PI/2

func _input(event: InputEvent) -> void:
	if !active: return
	if event is InputEventKey and event.pressed and !event.echo:
		match event.keycode:
			KEY_SPACE:
				velocity = velocity.rotated(velocity.angle_to(get_local_mouse_position())) * 0.8
				if bar.fish.collision in %collision.get_overlapping_areas(): bar.fish.progress += bar.fish.progress_increment() * 0.2

func _draw() -> void:
	draw_circle(Vector2.ZERO, StarFish.PLAYER_INFLUENCE, Color.WHITE, false, 4)
