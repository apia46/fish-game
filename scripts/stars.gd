extends Node2D

@onready var item:RID = get_canvas_item()
const STAR:Texture2D = preload("res://assets/level_4/star.png")

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	for i in 400:
		RenderingServer.canvas_item_add_texture_rect(item, Rect2(Vector2(randf_range(0, 2000), randf_range(0, 2000)), Vector2(7,9)), STAR)
