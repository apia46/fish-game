extends Control
class_name Game

@onready var progress_bar:ProgressBar = %progressBar
@onready var accuracy_label:Label = %accuracyLabel
@onready var win_text:Label = %winText
@onready var scene:Control = %tutorial

func _start() -> void:
	%tutorial.start()
	%startButton.queue_free()
