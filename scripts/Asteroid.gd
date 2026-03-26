class_name Asteroid
extends Sprite2D

const TEXTURES:Array[Texture2D] = [
	preload("res://assets/level_4/asteroid.png"),
	preload("res://assets/level_4/asteroid2.png"),
	preload("res://assets/level_4/asteroid3.png")
]

@onready var parent:Circle = get_parent()
var phase:float = 0
var speed:float = 1

func _ready() -> void:
	texture = TEXTURES[randi_range(0,2)]

func _process(delta: float) -> void:
	modulate.a = parent.asteroid_opacity
	phase += delta * speed
	if phase > TAU: phase -= TAU
	position = Vector2(parent.orbit_radius, 0).rotated(phase)
