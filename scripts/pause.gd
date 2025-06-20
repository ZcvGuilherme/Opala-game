extends CanvasLayer

func _ready():
	visible = false


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
	
func _on_resume_pressed():
	get_tree().paused = false
	visible = false
	


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
