class_name ProcessTimer
extends Timer

var process_function:Callable

func _process(delta:float) -> void:
	process_function.call(delta)

func with_function(function:Callable) -> ProcessTimer:
	process_function = function
	return self
