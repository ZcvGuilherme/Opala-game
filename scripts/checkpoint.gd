extends Area2D

var is_active = false

func _on_body_entered(body: Node2D) -> void:
	activate_checkpoint()
	
func activate_checkpoint():
	print("Player no checkpoint")
	is_active = true
