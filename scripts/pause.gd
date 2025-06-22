extends CanvasLayer

func _ready():
	visible = false
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		if !visible:
			visible = true
			get_tree().paused = true
		else:
			_on_resume_pressed()
	
func _on_resume_pressed():
	get_tree().paused = false
	visible = false
func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
