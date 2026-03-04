extends Control
class_name Tutorial

@onready var tutorial_text:Label = %tutorialText

var dash_tutorialed:bool = false
var dash_tutorialing:bool = false

func _ready() -> void:
	%bar.player.position.y = %bar.size.y - %bar.player.half_height()

func start() -> void:
	%bar.start()

func dash_tutorial() -> void:
	dash_tutorialing = true
	dash_tutorialed = true
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 0, 0.3)
	tween.tween_interval(0.5)
	tween.tween_callback(func(): tutorial_text.visible = true)

func dash_tutorial_finish() -> void:
	dash_tutorialing = false
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 1, 0.3)
	tween.tween_callback(func(): tutorial_text.text = "Press space to dash, which gives a small amount of progress.")

func dash_tutorial_skip() -> void:
	dash_tutorialed = true
	tutorial_text.visible = true
	tutorial_text.text = "Press space to dash, which gives a small amount of progress."
