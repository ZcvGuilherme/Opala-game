extends Area2D

@export var active_duration: float = 1.0
@export var repeat_interval: float = 2.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	timer.wait_time = repeat_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "activating":
		animation_player.play("active")
		get_tree().create_timer(active_duration).timeout.connect(deactive)
	elif anim_name == "deactivate":
		timer.start()
func deactive():
	animation_player.play("deactivate")
func _on_timer_timeout() -> void:
	animation_player.play("activating")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
