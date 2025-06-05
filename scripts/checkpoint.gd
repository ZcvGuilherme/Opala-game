extends Area2D

@export var checkpoint_id: String = ""

signal checkpoint_activated(id: String, position: Vector2)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("checkpoint_activated", checkpoint_id, global_position)
