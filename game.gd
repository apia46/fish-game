extends Control
class_name Game

@onready var progress_bar:ProgressBar = %progressBar
@onready var accuracy_label:Label = %accuracyLabel
@onready var tutorial:Label = %tutorial

func _ready() -> void:
	%bar.player.position.y = %bar.size.y - %bar.player.half_height()

func _start() -> void:
	%bar.start()
	%startButton.queue_free()
