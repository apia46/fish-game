extends Node2D
class_name Circle

var color:Color = Color(Color.WHITE, 0):
	set(to):
		color = to
		queue_redraw()
var radius:float = 0:
	set(to):
		radius = to
		queue_redraw()
var orbit_radius:float = 16
var asteroid_opacity:float = 0

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color, false, 4)
