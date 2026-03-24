@abstract
extends Sprite2D
class_name Fish

@onready var game:Game = $"/root/game"
@onready var bar:Bar = get_parent()
@onready var collision:Area2D = %collision

const HALF_HEIGHT:float = 16

var timers_id_iter:int = 0

const STATE_NONE:int = 0
const STATE_NONPROGRESS:int = 1
var states:Dictionary[int, int]
var timers:Dictionary[int, Timer]

var velocity:Vector2 = Vector2.ZERO

var time:float = 0
var time_unhooked:float = 0
var time_hooked:float = 0
var phase:int = 0
var progress:float = 0

var active:bool = false

@onready var level:Level = game.level

func _process(delta: float) -> void:
	if !active: return
	position += velocity * delta
	position.y = clamp(position.y, HALF_HEIGHT, bar.size.y-HALF_HEIGHT)
	if !has_state(STATE_NONPROGRESS):
		self_modulate.a = 1
		time += delta
		if touching_player():
			time_hooked += delta
			progress += delta * progress_increment()
		else:
			time_unhooked += delta
			progress -= delta * progress_increment()
	else:
		self_modulate.a = 0.5
	progress = clamp(progress, self.PHASES[phase], 1)
	level.hud.progress_bar.value = progress
	if progress >= 1: level.win()
	elif progress > self.PHASES[phase+1]:
		phase += 1
		phase_increased()
	var accuracy:float = 1 - time_unhooked/time
	level.hud.accuracy_label.text = "Accuracy: %.1f%%" % (accuracy * 100)

func penalty(amount:float) -> void:
	progress -= amount * progress_increment()
	time_unhooked += amount
	time += amount

func touching_player() -> bool: return bar.player.collision in %collision.get_overlapping_areas()

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
	timer.timeout.connect(reciever)
	return timer

func create_looping_timer_with_id(state:int, duration:float, reciever:Callable) -> Timer:
	var timer:Timer = _create_timer(state, duration, Timer)
	var id:int = timers_id_iter - 1
	timer.timeout.connect(reciever.bind(id))
	return timer

func _create_oneshot_timer(state:int, duration:float, reciever:Callable, with_id:bool, type) -> Timer:
	var timer:Timer = _create_timer(state, duration, type)
	var id:int = timers_id_iter - 1
	timer.one_shot = true
	timer.timeout.connect(func() -> void:
		if with_id: reciever.call(id)
		else: reciever.call()
		cancel_timer(id, "timeout")
	)
	return timer

func create_oneshot_timer(state:int, duration:float, reciever:Callable=func():return) -> Timer:
	return _create_oneshot_timer(state, duration, reciever, false, Timer)

func create_oneshot_timer_with_id(state:int, duration:float, reciever:Callable) -> Timer:
	return _create_oneshot_timer(state, duration, reciever, true, Timer)

func create_oneshot_process_timer(state:int, duration:float, reciever:Callable=func():return) -> ProcessTimer:
	return _create_oneshot_timer(state, duration, reciever, false, ProcessTimer)

func has_state(state:int) -> bool: return state in states.values()

func cancel_timers(state:int) -> void:
	for id in states.keys():
		if states[id] == state:
			cancel_timer(id, "cancel timers")

func cancel_timer(id:int, why:String) -> void:
	assert(timers.get(id))
	print("cancelling id %s %s" % [id, why])
	timers[id].stop()
	timers[id].queue_free()
	timers.erase(id)
	states.erase(id)

@abstract func start() -> void
@abstract func phase_increased() -> void
@abstract func progress_increment() -> float
