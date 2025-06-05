extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		var timer := get_tree().create_timer(2.0)
		print("⚠️ O jogador morreu!")
		
func _on_death_() -> void:
	get_tree().reload_current_scene()
