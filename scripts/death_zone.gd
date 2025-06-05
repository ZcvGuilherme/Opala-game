extends Area2D

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		
		print("⚠️ O jogador morreu!")
		
func _on_death_() -> void:
	get_tree().reload_current_scene()
