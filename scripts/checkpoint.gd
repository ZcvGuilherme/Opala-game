extends Area2D

var checkpoint_manager
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	checkpoint_manager = get_parent().get_parent().get_node("CheckManager")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.global_position
		checkpoint_manager.last_location = $RespawnPoint.global_position
		print("Player chegou aqui.")
	
