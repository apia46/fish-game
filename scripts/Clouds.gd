extends Node2D
class_name Clouds

const TEXTURE:Texture2D = preload("res://assets/level_3/cloud.png")

var time:float
@onready var item:RID = get_canvas_item()

func _process(delta:float) -> void:
	time += delta
	if time > 1: time -= 1
	queue_redraw()

func _draw() -> void:
	RenderingServer.canvas_item_add_texture_rect(item, Rect2(Vector2(time*-200,0), Vector2(1352,200)), TEXTURE, true)
