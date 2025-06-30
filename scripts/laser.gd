extends Node2D

@export var active_duration: float = 1.0
@export var repeat_interval: float = 2.0
@export var eternal := false

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = repeat_interval
	if eternal:
		animation_player.play("idle")
		timer.stop()
	else:
		timer.start()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
		
func _on_timer_timeout() -> void:
	animation_player.play("activating")

func deactivate():
	animation_player.play("deactivating")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "activate":
		animation_player.play("idle")
		get_tree().create_timer(active_duration).timeout.connect(deactivate)
	elif anim_name == "deactivate":
		if repeat_interval > 0:
			timer.start()
