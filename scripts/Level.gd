@abstract
extends Control
class_name Level

@onready var game:Game = $"/root/game"
@onready var hud:Hud = %hud

@abstract func start() -> void

@abstract func win() -> void

func get_gravity() -> float: return 100

func get_dash_loss() -> float: return 0.8
