extends Control
class_name Game

@onready var win_text:Label = %winText
@onready var scene:Control

func _ready() -> void:
	scene = preload("res://scenes/tutorial.tscn").instantiate()
	add_child(scene)

func _start() -> void:
	#scene.start()
	start_level_1()
	%startButton.queue_free()

func start_level_1() -> void:
	scene.queue_free()
	scene = preload("res://scenes/level_1.tscn").instantiate()
	add_child(scene)
	await get_tree().create_timer(0.5).timeout
	scene.start()
