extends Area2D
@export var respawn_offset: Vector2 = Vector2.ZERO


@onready var respawn_point: Marker2D = $RespawnPoint

var checkpoint_manager

func _ready() -> void:
	checkpoint_manager = get_parent().get_parent().get_node("CheckpointManager")
	
	respawn_point.global_position = global_position + respawn_offset
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		checkpoint_manager.last_location = respawn_point.global_position
		print("Player ativou o checkpoint.")
