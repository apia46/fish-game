extends Panel

@onready var lines:Array[Label] = [%line0, %line1, %line2, %line3, %line4, %line5]
var line:int = 0
var timer:float = -1

func _ready() -> void:
	visible = true
	for label in lines: if label: label.modulate.a = 0

func _process(delta: float) -> void:
	if line < len(lines) - 1:
		if timer >= 1.5:
			lines[line].modulate.a = 1
			if line == 3: timer = -1
			else: timer = 0
			line += 1
	if line < len(lines):
		lines[line].modulate.a = clamp(timer,0,1)
		timer += delta

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		if line == len(lines) - 1 and timer >= 1.5:
			var tween:Tween = get_tree().create_tween()
			tween.tween_property(self, ^"modulate", Color(Color.WHITE, 0), 0.5)
			tween.tween_callback(queue_free)
		else: timer = 1.5
