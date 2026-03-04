extends Control
class_name Game

@onready var progress_bar:ProgressBar = %progressBar
@onready var accuracy_label:Label = %accuracyLabel
@onready var win_text:Label = %winText
@onready var scene:Control = %tutorial

func _start() -> void:
	%tutorial.start()
	%startButton.queue_free()

func start_level_1() -> void:
	%tutorial.queue_free()
	scene = preload("res://scenes/level_1.tscn").instantiate()
	add_child(scene)
