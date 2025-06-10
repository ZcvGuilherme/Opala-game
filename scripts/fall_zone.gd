extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("handle_death_zone"):
		body.handle_death_zone()
		print("game over")
	
