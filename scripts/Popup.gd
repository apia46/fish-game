extends Panel
class_name GamePopup

signal closed

var text:String:
	set(to):
		text = to
		%Label.text = text

var button_text:String:
	set(to):
		button_text = to
		%Button.text = button_text

static func create(parent:Node, popup_text:String, popup_button_text:String) -> GamePopup:
	var popup:GamePopup = preload("res://scenes/popup.tscn").instantiate()
	popup.text = popup_text
	popup.button_text = popup_button_text
	parent.add_child(popup)
	return popup

func _ready() -> void:
	scale = Vector2.ZERO
	var tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_ignore_time_scale()
	tween.tween_property(self, ^"scale", Vector2.ONE, 0.2)

func _close() -> void:
	var tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN).set_ignore_time_scale()
	tween.tween_property(self, ^"scale", Vector2.ZERO, 0.2)
	tween.tween_callback(func():
		closed.emit(); queue_free()
	)
	
