extends Sprite2D

@onready var game:Game = $"/root/game"
@onready var collision:Area2D = %collision

var time:float = 0
var progress:float = 0
var time_unhooked:float = 0

func _process(delta: float) -> void:
    time += delta
    position.y += sin(time) * delta * 100
    if game.player.collision in %collision.get_overlapping_areas():
        progress += delta / 10
    else:
        progress -= delta / 10
        time_unhooked += delta
    game.progress_bar.value = progress
    game.accuracy_label.text = "Accuracy: %.1f%%" % ((1 - time_unhooked/time) * 100)
