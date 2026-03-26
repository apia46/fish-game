extends Control
class_name Hud

@onready var progress_bar:TextureProgressBar = %progressBar
@onready var accuracy_label:Label = %accuracyLabel

@export var progress_fill:Texture2D

func _ready() -> void:
	progress_bar.texture_progress = progress_fill
