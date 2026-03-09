extends Control
class_name Game

@onready var progress_bar:ProgressBar = %progressBar
@onready var accuracy_label:Label = %accuracyLabel
@onready var win_text:Label = %winText
@onready var scene:Control

func _ready() -> void:
	scene = preload("res://scenes/tutorial.tscn").instantiate()
	add_child(scene)

func _start() -> void:
	scene.start()
	%startButton.queue_free()

func start_level_1() -> void:
	scene.queue_free()
	scene = preload("res://scenes/level_1.tscn").instantiate()
	add_child(scene)
	await get_tree().process_frame
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 1, 0.3)
