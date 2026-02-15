extends Sprite2D

@onready var bar:Panel = get_parent()
@onready var collision:Area2D = %collision

const HALF_BAR_HEIGHT:float = 40

var velocity:Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	velocity.y += delta * 100 # gravity
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): velocity.y += delta * -300
		
	position += velocity * delta

	if position.y < HALF_BAR_HEIGHT: # bounce off top
		position.y = HALF_BAR_HEIGHT
		if velocity.y < 0: velocity.y *= -0.8
	if position.y > bar.size.y - HALF_BAR_HEIGHT: # bounce off bottom
		position.y = bar.size.y - HALF_BAR_HEIGHT
		if velocity.y > 0: velocity.y *= -0.8

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and !event.echo:
		match event.keycode:
			KEY_SPACE: velocity.y *= -0.8 # dash attack
