extends Control

@onready var timer_counter: Label = $container/timer_container/timer_counter
@onready var clock_timer: Timer = $clock_timer

var minutes = 0
var seconds = 0

func _on_clock_timer_timeout() -> void:
	seconds += 1
	if seconds > 59:
		minutes += 1
		seconds = 0 
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds) 
