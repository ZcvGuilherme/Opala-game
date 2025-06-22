extends Control

@onready var timer_counter: Label = $container/timer_container/timer_counter
@onready var clock_timer: Timer = $clock_timer
@onready var death_counter: Label = $container/death_container/death_counter

var minutes = 0
var seconds = 0

func _ready() -> void:
	update_death_counter()
	
func _process(delta: float) -> void:
	update_death_counter()
	
func update_death_counter():
	death_counter.text = "%03d" % Globals.death_count

func _on_clock_timer_timeout() -> void:
	seconds += 1
	if seconds > 59:
		minutes += 1
		seconds = 0 
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds) 
