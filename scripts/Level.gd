@abstract
extends Control
class_name Level

@onready var game:Game = $"/root/game"

@abstract func win() -> void
