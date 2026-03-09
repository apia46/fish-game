extends Level
class_name Tutorial

@onready var tutorial_text:Label = %tutorialText

var dash_tutorialed:bool = false
var dash_tutorialing:bool = false

var time:float = 0
var text_offsets:Array[float] = []

func _ready() -> void:
	%bar.player.position.y = %bar.size.y - %bar.player.half_height()
	for_title_text(func(text:Sprite2D, index:int):
		text.position.x = (index - 3)*80
		text_offsets.append(0)
	)

func start() -> void:
	%bar.start()
	for_title_text(func(_text, index:int):
		var text_tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		text_tween.tween_interval(index*0.2)
		text_tween.tween_method(func(offset:float): text_offsets[index] = offset, 0, -250, 2.5)
	)
	var tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%bar, ^"position:x", %bar.position.x - 200, 2)

func _process(delta:float) -> void:
	time += delta
	if time > TAU: time -= TAU
	for_title_text(func(text:Sprite2D, index:int):
		var adjusted_index = index - 4 + int(index > 3)
		text.position.x = adjusted_index*80
		text.position.y = text_offsets[index] + cos(time+index) * 10 + 75 + 5*adjusted_index**2
		text.rotation = (index-3.5)*0.1 + cos(time+index)*0.2
	)

func for_title_text(lambda:Callable) -> void:
	var index:int = 0
	for text in %title.get_children():
		lambda.call(text, index)
		index += 1

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

func win() -> void:
	var tween:Tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine, ^"time_scale", 0, 0.3)
	tween.tween_callback(func(): game.win_text.visible = true)
	tween.tween_interval(0.5)
	tween.tween_callback(func(): game.win_text.visible = false)
	tween.tween_callback(game.start_level_1)
