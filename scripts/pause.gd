extends CanvasLayer
@onready var clock_timer: Timer = $Control/clock_timer

func _ready():
	visible = false
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		if !visible:
			visible = true
			get_tree().paused = true
			clock_timer.stop()
		else:
			_on_resume_pressed()
	
func _on_resume_pressed():
	get_tree().paused = false
	visible = false
	clock_timer.start()
func _on_quit_pressed():
	get_tree().quit()
