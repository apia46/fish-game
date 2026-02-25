extends Node2D
class_name Game

@onready var progress_bar:ProgressBar = %progressBar
@onready var accuracy_label:Label = %accuracyLabel

func _ready() -> void:
	%bar.player.position.y = %bar.size.y - %bar.player.HALF_HEIGHT

func _start() -> void:
	%bar.start()
