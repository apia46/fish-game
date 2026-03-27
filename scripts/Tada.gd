extends Node2D
class_name Tada

@onready var sprite:Sprite2D = %sprite
@onready var text:CurvedText = %text

var display_text:String:
	set(to):
		display_text = to
		%text.text = to
