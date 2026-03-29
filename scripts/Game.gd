extends Control
class_name Game

@onready var level:Control

var skip_tutorials:bool = false

var stats:Array[String] = []

func _ready() -> void:
	level = preload("res://scenes/tutorial.tscn").instantiate()
	add_child(level)

func _start() -> void:
	level.start()
	#start_level(preload("res://scenes/level_4.tscn"))
	%startButton.queue_free()

func start_level(scene:PackedScene) -> void:
	level.queue_free()
	level = scene.instantiate()
	add_child(level)
	level.start()

static func new_tada(text:String) -> Tada:
	var tada:Tada = preload("res://scenes/tada.tscn").instantiate()
	tada.display_text = text
	return tada

func end() -> void:
	level.queue_free()
	level = preload("res://scenes/end.tscn").instantiate()
	add_child(level)
