extends Control
class_name Game

@onready var win_text:Label = %winText
@onready var level:Control

func _ready() -> void:
	level = preload("res://scenes/tutorial.tscn").instantiate()
	add_child(level)

func _start() -> void:
	#level.start()
	start_level(preload("res://scenes/level_4.tscn"))
	%startButton.queue_free()

func start_level(scene:PackedScene) -> void:
	level.queue_free()
	level = scene.instantiate()
	add_child(level)
	level.start()
