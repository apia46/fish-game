@abstract
extends Sprite2D
class_name Fish

@onready var game:Game = $"/root/game"
@onready var bar:Bar = get_parent()
@onready var collision:Area2D = %collision

var timers_id_iter:int = 0

const STATE_NONE:int = 0
const STATE_NONPROGRESS:int = 1
var states:Dictionary[int, int]
var timers:Dictionary[int, Timer]

var velocity:Vector2 = Vector2.ZERO

var time:float = 0
var time_unhooked:float = 0
var time_hooked:float = 0
var bonus_progress:float = 0

func _process(delta: float) -> void:
	position += velocity * delta
	position.y = clamp(position.y, self.HALF_HEIGHT, bar.size.y-self.HALF_HEIGHT)
	if !has_state(STATE_NONPROGRESS):
		time += delta
		if bar.player.collision in %collision.get_overlapping_areas():
			time_hooked += delta
		else:
			time_unhooked += delta
	game.progress_bar.value = clamp((time_hooked - time_unhooked + bonus_progress) / 60, 0, 1)
	print(time_unhooked)
	game.accuracy_label.text = "Accuracy: %.1f%%" % ((1 - time_unhooked/time) * 100)

func _create_timer(state:int, duration:float, type) -> Timer:
	var timer:Timer = type.new()
	var id:int = timers_id_iter
	add_child(timer)
	timer.start(duration)
	states[id] = state
	timers[id] = timer
	timers_id_iter += 1
	return timer

func create_looping_timer(state:int, duration:float, reciever:Callable) -> Timer:
	var timer:Timer = _create_timer(state, duration, Timer)
	var id:int = timers_id_iter - 1
	timer.timeout.connect(func() -> void:
		states.erase(id)
		timers.erase(id)
		reciever.call()
	)
	return timer

func _create_oneshot_timer(state:int, duration:float, reciever:Callable, type) -> Timer:
	var timer:Timer = _create_timer(state, duration, type)
	var id:int = timers_id_iter - 1
	timer.one_shot = true
	timer.timeout.connect(func() -> void:
		states.erase(id)
		timers.erase(id)
		reciever.call()
		timer.queue_free()
	)
	return timer

func create_oneshot_timer(state:int, duration:float, reciever:Callable) -> Timer:
	return _create_oneshot_timer(state, duration, reciever, Timer)

func create_oneshot_process_timer(state:int, duration:float, reciever:Callable) -> ProcessTimer:
	return _create_oneshot_timer(state, duration, reciever, ProcessTimer)

func has_state(state:int) -> bool: return state in states.values()

func cancel_timers(state:int) -> void:
	for id in states.keys():
		if states[id] == state:
			timers[id].queue_free()
			timers.erase(id)
			states.erase(id)
